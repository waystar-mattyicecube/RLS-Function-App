# Microsoft Graph API URL to fetch users with specific columns
$graphApiUrl = "https://graph.microsoft.com/v1.0/users?`$select=userPrincipalName,displayName,mail,jobTitle,department,officeLocation,mobilePhone,accountEnabled,createdDateTime,lastPasswordChangeDateTime"

# Use Access Token to call Microsoft Graph API
$response = Invoke-RestMethod -Method Get -Uri $graphApiUrl -Headers @{
    Authorization = "Bearer $($token)"
}

# List the users from the response
$users = $response.value

# Example of fetching custom security attributes (assumed as extension properties)
# Replace 'customSecurityAttribute1' and 'customSecurityAttribute2' with the actual attribute names if they're stored as extensions or directory schema extensions
$customAttributesUrl = "https://graph.microsoft.com/v1.0/users/{user_id}?`$select=extension_customSecurityAttribute1,extension_customSecurityAttribute2"

foreach ($user in $users) {
    Write-Host "User Principal Name: $($user.userPrincipalName)"
    Write-Host "Display Name: $($user.displayName)"
    Write-Host "Email: $($user.mail)"
    Write-Host "Job Title: $($user.jobTitle)"
    Write-Host "Department: $($user.department)"
    Write-Host "Office Location: $($user.officeLocation)"
    Write-Host "Mobile Phone: $($user.mobilePhone)"
    Write-Host "Account Enabled: $($user.accountEnabled)"
    Write-Host "Created DateTime: $($user.createdDateTime)"
    Write-Host "Last Password Change: $($user.lastPasswordChangeDateTime)"

    # Query for custom attributes
    $customResponse = Invoke-RestMethod -Method Get -Uri $customAttributesUrl.Replace("{user_id}", $user.id) -Headers @{
        Authorization = "Bearer $($token)"
    }

    $customSecurityAttr1 = $customResponse.extension_customSecurityAttribute1
    $customSecurityAttr2 = $customResponse.extension_customSecurityAttribute2

    Write-Host "Custom Security Attribute 1: $customSecurityAttr1"
    Write-Host "Custom Security Attribute 2: $customSecurityAttr2"
}
