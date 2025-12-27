<#
.SYNOPSIS
Exports Microsoft 365 licensed users.

.DESCRIPTION
Connects to Microsoft Graph and exports users with assigned licenses.

.AUTHOR
Nduvho Madzivhandila
#>

Import-Module Microsoft.Graph.Users
Connect-MgGraph -Scopes "User.Read.All"

Get-MgUser -All |
Where-Object { $_.AssignedLicenses.Count -gt 0 } |
Select-Object DisplayName, UserPrincipalName |
Export-Csv ".\M365LicensedUsers.csv" -NoTypeInformation

Write-Output "Microsoft 365 license report exported."
