# Microsoft Graph API URL to fetch users with specific columns
$graphApiUrl = "https://graph.microsoft.com/v1.0/users?`$select=userPrincipalName,displayName,mail,jobTitle,department,officeLocation,mobilePhone,accountEnabled,createdDateTime,lastPasswordChangeDateTime"

# Use Access Token to call Microsoft Graph API
$response = Invoke-RestMethod -Method Get -Uri $graphApiUrl -Headers @{
    Authorization = "Bearer $($token)"
}

# List the users from the response
$users = $response.value

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

    # Query for custom attributes (EntraAccessLevel as an example)
    $customAttributesUrl = "https://graph.microsoft.com/v1.0/users/$($user.id)?`$select=extension_EntraAccessLevel"
    $customResponse = Invoke-RestMethod -Method Get -Uri $customAttributesUrl -Headers @{
        Authorization = "Bearer $($token)"
    }

    # Output custom attribute values
    $EntraAccessLevel = $customResponse.extension_EntraAccessLevel
    Write-Host "EntraAccessLevel: $EntraAccessLevel"
}
