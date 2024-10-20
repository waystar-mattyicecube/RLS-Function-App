# Azure Functions profile.ps1
#
# This profile.ps1 will get executed on every "cold start" of your Function App.
# A "cold start" occurs when:
# * A Function App starts up for the very first time
# * A Function App starts up after being de-allocated due to inactivity
#
# You can define helper functions, run commands, or specify environment variables
# NOTE: Any variables defined that are not environment variables will get reset after the first execution.

# Authenticate with Azure PowerShell using MSI (Managed Service Identity) if required.
# This section authenticates your function with Azure if it needs to interact with Azure resources.
if ($env:MSI_SECRET) {
    Disable-AzContextAutosave -Scope Process | Out-Null
    Connect-AzAccount -Identity
}

# Import the MSOnline module to enable interaction with Azure AD
# Replace the path with the correct one where you've uploaded the MSOnline module in your Azure Function App

$modulePath = "C:\Users\matthew.elliott\Desktop\MSOnline"  # Adjust the path if the module is in a different directory
if (Test-Path $modulePath) {
    Import-Module $modulePath
    Write-Host "MSOnline module imported successfully."
} else {
    Write-Host "MSOnline module not found at $modulePath."
}

# Define environment variables (if needed)
# Example: Set Snowflake credentials if you're also working with Snowflake
$env:SNOWFLAKE_USER = "your_snowflake_user"
$env:SNOWFLAKE_PASSWORD = "your_snowflake_password"
$env:SNOWFLAKE_ACCOUNT = "your_snowflake_account"

# Helper functions for common tasks (if needed)
function Get-CurrentDate {
    return (Get-Date).ToString("yyyy-MM-dd")
}

# Output a message to indicate that the profile.ps1 script ran successfully
Write-Host "profile.ps1 executed successfully."
