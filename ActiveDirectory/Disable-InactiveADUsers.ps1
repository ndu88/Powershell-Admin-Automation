Import-Module ActiveDirectory

$DaysInactive = 90
$CutoffDate = (Get-Date).AddDays(-$DaysInactive)

$InactiveUsers = Get-ADUser -Filter {
    Enabled -eq $true -and LastLogonDate -lt $CutoffDate
} -Properties LastLogonDate

foreach ($User in $InactiveUsers) {
    Disable-ADAccount -Identity $User.SamAccountName
    Write-Output "Disabled user: $($User.SamAccountName)"
}
