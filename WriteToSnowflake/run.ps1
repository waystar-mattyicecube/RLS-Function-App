# Load Snowflake connection details from environment variables
$snowflakeUser = $env:SNOWFLAKE_USER
$snowflakePassword = $env:SNOWFLAKE_PASSWORD
$snowflakeAccount = $env:SNOWFLAKE_ACCOUNT
$snowflakeWarehouse = $env:SNOWFLAKE_WH
$snowflakeDatabase = $env:SNOWFLAKE_DB
$snowflakeSchema = $env:SNOWFLAKE_SCHEMA

# Construct the connection string using the environment variables
$connectionString = "User=$snowflakeUser;Password=$snowflakePassword;Account=$snowflakeAccount;Warehouse=$snowflakeWarehouse;Database=$snowflakeDatabase;Schema=$snowflakeSchema"

# Define the user profile data (you would replace this with actual user data retrieved from Microsoft Graph API)
$userPrincipalName = "user@example.com"
$displayName = "Example User"
$mail = "user@example.com"
$mobilePhone = "123-456-7890"
$jobTitle = "Developer"
$entraAccessLevel = "Level1"  # This is your custom EntraAccessLevel attribute
$department = "Engineering"

# Example Snowflake SQL Command to INSERT the user profile data into a table
$insertQuery = @"
    INSERT INTO UserProfiles (UserPrincipalName, DisplayName, Mail, MobilePhone, JobTitle, EntraAccessLevel, Department)
    VALUES ('$userPrincipalName', '$displayName', '$mail', '$mobilePhone', '$jobTitle', '$entraAccessLevel', '$department');
"@

try {
    # Open connection to Snowflake using the connection string
    $snowflakeConnection = New-Object System.Data.Odbc.OdbcConnection($connectionString)
    $snowflakeConnection.Open()

    # Create a new ODBC command to execute the SQL query
    $snowflakeCommand = $snowflakeConnection.CreateCommand()
    $snowflakeCommand.CommandText = $insertQuery

    # Execute the INSERT query
    $snowflakeCommand.ExecuteNonQuery()

    Write-Host "Data successfully inserted into Snowflake."

    # Close the connection
    $snowflakeConnection.Close()
} catch {
    # Catch any exceptions and write error message
    Write-Host "Error while writing to Snowflake: $_"
} finally {
    # Ensure the connection is closed in case of an error
    if ($snowflakeConnection.State -eq "Open") {
        $snowflakeConnection.Close()
    }
}
