================================================================================
                        Batch Script Setup and Usage Guide


This script is designed to automate various tasks related to downloading WAR files,
updating configuration files, and deploying them to a WildFly server.

Below are the instructions on how to set up and run the script:

--------------------------------------------------------------------------------
1. Prerequisites:
--------------------------------------------------------------------------------
- Windows OS with `curl` and `mysql` command line tools available.
- Correct paths for your local directories and server configurations.
- MySQL connection details (host, port, username, password).
- WildFly server IP address and management port.
- Nexus repository details (host, repository).
- A `application.properties` file that you want to modify based on database settings.

--------------------------------------------------------------------------------
2. Script Configuration:
--------------------------------------------------------------------------------

### Edit the script to set the following variables:
1. **Download Directory**: Where the WAR files will be downloaded.
   - Example: `set DOWNLOAD_DIR=C:\path\to\your\downloads`

2. **WAR Files Directory**: Directory where WAR files are stored.
   - Example: `set WAR_FILES_DIR=C:\path\to\your\war\files`

3. **MySQL Credentials**:
   - **MYSQL_HOST**: MySQL server host (use `localhost` for local).
   - **MYSQL_PORT**: Default MySQL port is `3306`.
   - **MYSQL_USERNAME**: MySQL username.
   - **MYSQL_PASSWORD**: MySQL password.
   - **MYSQL_NAME**: MySQL database name.

4. **WildFly Server Configuration**:
   - **WILDFLY_HOST**: IP address or hostname of your WildFly server.
   - **WILDFLY_PORT**: WildFly's management port (default is `9991`).

5. **Nexus Repository Configuration**:
   - **NEXUS_HOST**: Nexus repository server IP.
   - **MAVEN_GROUP**: Group ID for the artifact in Maven.
   - **MAVEN_ARTIFACT**: Artifact ID for the WAR file.
   - **MAVEN_BASE_VERSION**: Version of the artifact to download.
   - **MAVEN_EXTENSION**: Type of artifact (usually `.war`).

6. **Paths to Files**:
   - **INPUT_PROP_FILE**: Path to the original `application.properties` file.
   - **OUTPUT_PROP_FILE**: Path where the updated `application.properties` file will be saved.

--------------------------------------------------------------------------------
3. Available Tasks:
--------------------------------------------------------------------------------

### Option A: Fetch the latest WAR
- This option fetches the latest WAR file from a Nexus repository based on the configurations you provide.
- The WAR file will be downloaded to the directory specified in the `DOWNLOAD_DIR`.

### Option B: Update `application.properties`
- This task updates the `application.properties` file with the MySQL connection details.
- The script will replace placeholders (e.g., `${DB_HOST}`) in the `application.properties` file with your actual database details.

### Option C: Update the downloaded WAR (Placeholder task)
- Placeholder for additional functionality to modify the downloaded WAR file.
- Currently, the script only prints the task but doesn't perform any action for this option.

### Option D: Deploy WAR to WildFly Server
- Placeholder for deploying the WAR file to the WildFly server using the CLI.
- Once you configure WildFly, this option can be activated to deploy the WAR file.

--------------------------------------------------------------------------------
4. Running the Script:
--------------------------------------------------------------------------------
1. Open a **Command Prompt** in the directory where the batch script is located.
2. Type the script name and hit Enter: `script_name.bat`.
3. Follow the on-screen prompts to choose the task to execute.
4. You can choose to execute:
   - All tasks (ALL)
   - Fetch latest WAR (A)
   - Update `application.properties` (B)
   - Deploy WAR (D)
   - Exit (X)

--------------------------------------------------------------------------------
5. Troubleshooting:
--------------------------------------------------------------------------------
- If you receive errors related to MySQL or WildFly, check your credentials and server IP addresses.
- Ensure that your Nexus repository is accessible from the script's machine and that the WAR file exists in the repository.

--------------------------------------------------------------------------------
6. Notes:
--------------------------------------------------------------------------------
- This script assumes the use of `mysql` command line tool for testing MySQL connections.
- The script uses `curl` to download the WAR file. Ensure it's installed on your system.

================================================================================
