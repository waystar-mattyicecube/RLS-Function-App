# Load Azure AD credentials from environment variables
$tenantId = $env:TENANT_ID
$clientId = $env:CLIENT_ID
$clientSecret = $env:CLIENT_SECRET

# Validate that environment variables were retrieved successfully
if (-not $tenantId -or -not $clientId -or -not $clientSecret) {
    Write-Host "One or more Azure AD environment variables are missing."
    exit
}

# Define the scope for the Microsoft Graph API (using client credentials flow)
$scope = "https://graph.microsoft.com/.default"

# Token endpoint for OAuth2 authentication
$tokenEndpoint = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

# Request an access token from Azure AD
$response = Invoke-RestMethod -Method Post -Uri $tokenEndpoint -ContentType "application/x-www-form-urlencoded" -Body @{
    client_id     = $clientId
    scope         = $scope
    client_secret = $clientSecret
    grant_type    = "client_credentials"
}

# Extract the access token from the response
$token = $response.access_token

# Validate if the token was successfully retrieved
if (-not $token) {
    Write-Host "Failed to retrieve access token."
    exit
} else {
    Write-Host "Access token retrieved successfully."
}

# Use the access token to query Microsoft Graph
$graphApiUrl = "https://graph.microsoft.com/v1.0/users"

# Use the access token to call Microsoft Graph API and get the users
$response = Invoke-RestMethod -Method Get -Uri $graphApiUrl -Headers @{
    Authorization = "Bearer $($token)"
}

# Output the retrieved users from Microsoft Graph API
$users = $response.value

foreach ($user in $users) {
    Write-Host "User Principal Name: $($user.userPrincipalName)"
    Write-Host "Display Name: $($user.displayName)"
    Write-Host "Email: $($user.mail)"
    # Further processing or output here, if needed
}
