<#
.SYNOPSIS
Exports installed software.

.DESCRIPTION
Retrieves installed software from registry and exports to CSV.

.AUTHOR
Nduvho Madzivhandila
#>

$Software = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
Where-Object { $_.DisplayName } |
Select-Object DisplayName, DisplayVersion, Publisher

$Software | Export-Csv ".\InstalledSoftwareReport.csv" -NoTypeInformation

Write-Output "Installed software report exported."
