@echo off
setlocal enabledelayedexpansion

cls
echo Date format = %date%
echo dd = %date:~0,2%
echo mm = %date:~3,2%
echo yyyy = %date:~6,4%
echo.
echo Time format = %time%
echo hh = %time:~0,2%
echo mm = %time:~3,2%
echo ss = %time:~6,2%
echo.

:: Remove leading space from time (if any)
set time=%time: =0%

:: Generate the timestamp format: YYYY-MM-DD-HHMMSS
set TIMESTAMP=%date:~6,4%-%date:~3,2%-%date:~0,2%-%time:~0,2%%time:~3,2%%time:~6,2%

REM === PATHS ===
:: Replace the paths below with your specific directory paths
set DOWNLOAD_DIR=C:\path\to\your\downloads
set WAR_FILES_DIR=C:\path\to\your\war\files
set INPUT_PROP_FILE=C:\path\to\your\application.properties
set OUTPUT_PROP_FILE=C:\path\to\your\updated-application.properties
set TEMP_DIR=%USERPROFILE%\AppData\Local\Temp
set LOGFILE=C:\path\to\your\logs\log-%TIMESTAMP%.txt

REM === WILDFLY ===
:: Replace this with your WildFly host IP and port
set WILDFLY_HOST=your.wildfly.server.ip
set WILDFLY_PORT=9991  :: Default WildFly management port
set JBOSS_CLI=%WILDFLY_HOME%\bin\jboss-cli.bat
set CONTROLLER=%WILDFLY_HOST%:%WILDFLY_PORT%

REM === NEXUS ===
:: Replace this with your Nexus repository host IP
set NEXUS_HOST=your.nexus.server.ip
set DOWNLOAD_URL=http://%NEXUS_HOST%:8081/service/rest/v1/search/assets/download
set SORT=version
set MAVEN_GROUP=com.yourcompany
set MAVEN_ARTIFACT=yourartifact
set MAVEN_BASE_VERSION=0.0.1-SNAPSHOT
set MAVEN_EXTENSION=war

REM === MYSQL ===
:: Replace with your MySQL connection details
set MYSQL_HOST=localhost       :: MySQL server host IP (localhost for local)
set MYSQL_PORT=3306            :: Default MySQL port
set MYSQL_USERNAME=yourusername
set MYSQL_PASSWORD=yourpassword
set MYSQL_NAME=yourdatabase

REM === MAIN MENU ===
:menu
cls
echo ==================================
echo Main Menu - Select a Task
echo ==================================
echo Select the task(s) to execute:
echo [ALL] - Execute all tasks sequentially
echo [A] - Fetch the latest WAR
echo [B] - Update properties
echo [C] - Update WAR
echo [D] - Deploy WAR
echo [X] - Exit
echo ==================================
set /p task=Enter your choice : 
echo Selected choice: %task%
echo Tasks to execute: %task% >> "%LOGFILE%"

REM Execute tasks based on input
if /i "%task%"=="ALL" goto all_tasks
if /i "%task%"=="A" goto fetch_war
if /i "%task%"=="B" goto update_properties
if /i "%task%"=="C" goto update_war
if /i "%task%"=="D" goto deploy_war
if /i "%task%"=="X" (
    echo ================================== >> "%LOGFILE%"
    echo User exited the script. >> "%LOGFILE%"
    exit /b
)

REM === TASK A: FETCH THE LATEST WAR ===
:fetch_war
echo ================================== >> "%LOGFILE%"
echo Task A: Fetching the latest WAR... >> "%LOGFILE%"

REM Repository selection
echo Available repositories:
echo 1. maven-snapshots
echo 2. your-custom-repository

set /p choice=Select a repository by number: 
echo Selected Nexus repository: %choice%

set repository=
if "%choice%"=="1" set repository=maven-snapshots
if "%choice%"=="2" set repository=your-custom-repository

if "%repository%"=="" (
    echo Invalid selection. Exiting... >> "%LOGFILE%"
    pause
    exit /b 1
)

echo Selected Nexus Repository : %repository% >> "%LOGFILE%"

REM Construct download URL
set DOWNLOAD_FULL_URL=%DOWNLOAD_URL%?sort=%SORT%^&repository=%repository%^&maven.groupId=%MAVEN_GROUP%^&maven.artifactId=%MAVEN_ARTIFACT%^&maven.baseVersion=%MAVEN_BASE_VERSION%^&maven.extension=%MAVEN_EXTENSION%

REM Download the file using curl
set OUTPUT_FILE=%DOWNLOAD_DIR%\%repository%-%MAVEN_BASE_VERSION%-LAST.war

echo Downloading latest WAR from repository "%repository%"...

curl -L -X GET "%DOWNLOAD_FULL_URL%" --output "%OUTPUT_FILE%"

if not errorlevel 1 (
    echo File downloaded successfully as "%OUTPUT_FILE%" >> "%LOGFILE%"
) else (
    echo Error during download. Exiting... >> "%LOGFILE%"
    pause
    exit /b 1
)

echo Task A: DONE >> "%LOGFILE%"
pause
goto menu

REM === TASK B: UPDATE APPLICATION.PROPERTIES FILE ===
:update_properties
echo ================================== >> "%LOGFILE%"
echo Task B: Updating DATASOURCE...     >> "%LOGFILE%"

echo Testing MySQL connection... >> "%LOGFILE%"

echo Test de connexion à MySQL...
mysql -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USERNAME% -p%MYSQL_PASSWORD% --batch --silent -e "exit" >> "%LOGFILE%" 2>&1
if errorlevel 1 (
    echo Error in USERNAME/PASSWORD >> "%LOGFILE%"
) else (
    echo MYSQL is connected! --KEEP THE CREDENTIALS-- >> "%LOGFILE%"
)

if not exist "%INPUT_PROP_FILE%" (
    echo File "%INPUT_PROP_FILE%" not found! >> "%LOGFILE%"
    exit /b
)

:: Process the file line by line and replace placeholders
(
    for /f "usebackq delims=" %%L in ("%INPUT_PROP_FILE%") do (
        set "line=%%L"
        set "line=!line:${DB_HOST}=%DB_HOST%!"
        set "line=!line!${DB_PORT}=%DB_PORT%!"
        set "line=!line!${DB_NAME}=%DB_NAME%!"
        set "line=!line!${DB_USERNAME}=%DB_USERNAME%!"
        set "line=!line!${DB_PASSWORD}=%DB_PASSWORD%!"
        echo !line!
    )
) > "%OUTPUT_PROP_FILE%"

:: Notify the user
echo Placeholders have been updated in "%OUTPUT_PROP_FILE%".

echo Task B: DONE >> "%LOGFILE%"
pause
goto menu
