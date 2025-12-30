Import-Module ActiveDirectory

# Configuration
$InactiveDays  = 90
$WarningPeriod = 30
$CutoffDate    = (Get-Date).AddDays(-$InactiveDays)

$FromEmail   = "it-automation@company.co.za"
$SMTPServer = "smtp.company.co.za"
$LogFile    = "C:\Logs\InactiveUserWarning.log"

# Get inactive users
$InactiveUsers = Get-ADUser -Filter {
    Enabled -eq $true -and LastLogonDate -lt $CutoffDate
} -Properties LastLogonDate, Manager, EmailAddress

foreach ($User in $InactiveUsers) {

    Write-Output "Processing user: $($User.SamAccountName)"

    if ($User.Manager) {

        $Manager = Get-ADUser $User.Manager -Properties EmailAddress, Name

        if ($Manager.EmailAddress) {

            $Subject = "Inactive AD Account Warning – $($User.Name)"
            $Body = @"
Good day $($Manager.Name),

This is an automated notification to inform you that the following user account has been inactive for over $InactiveDays days:

User Name: $($User.Name)
Username: $($User.SamAccountName)
Last Logon Date: $($User.LastLogonDate)

If this employee is still part of the company, please advise them to log in within the next $WarningPeriod days.

Failure to do so will result in the account being disabled in line with security compliance policies.

If this account should remain active, please contact the IT team.

Kind regards,
IT Automation Team
"@

            Send-MailMessage `
                -To $Manager.EmailAddress `
                -From $FromEmail `
                -Subject $Subject `
                -Body $Body `
                -SmtpServer $SMTPServer

            # Log action
            Add-Content -Path $LogFile -Value "$(Get-Date) | Warning sent to manager of $($User.SamAccountName)"
        }
    }
}
