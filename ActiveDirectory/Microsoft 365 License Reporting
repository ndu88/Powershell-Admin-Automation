Import-Module Microsoft.Graph.Users

Connect-MgGraph -Scopes "User.Read.All"

$Users = Get-MgUser -All |
    Where-Object { $_.AssignedLicenses.Count -gt 0 } |
    Select-Object DisplayName, UserPrincipalName

$Users | Export-Csv ".\M365LicensedUsers.csv" -NoTypeInformation

Write-Output "Microsoft 365 license report exported."
