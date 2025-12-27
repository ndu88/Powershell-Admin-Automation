# Powershell-Admin-Automation
ActiveDirectory/New-ADUserFromCSV.ps1

Import-Module ActiveDirectory

$CsvPath = ".\users.csv"

$Users = Import-Csv $CsvPath

foreach ($User in $Users) {
    try {
        New-ADUser `
            -Name "$($User.FirstName) $($User.LastName)" `
            -GivenName $User.FirstName `
            -Surname $User.LastName `
            -SamAccountName $User.Username `
            -UserPrincipalName "$($User.Username)@domain.local" `
            -Enabled $true

        Write-Output "User $($User.Username) created successfully."
    }
    catch {
        Write-Error "Failed to create user $($User.Username): $_"
    }
}
