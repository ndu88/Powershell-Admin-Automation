<#
.SYNOPSIS
Generates system health report.

.DESCRIPTION
Collects CPU, memory, and disk usage.

.AUTHOR
Nduvho Madzivhandila
#>

$CPU = Get-CimInstance Win32_Processor | Select-Object Name, LoadPercentage
$Memory = Get-CimInstance Win32_OperatingSystem |
Select-Object @{
    Name="TotalMemoryGB"
    Expression={[math]::Round($_.TotalVisibleMemorySize / 1MB, 2)}
}, @{
    Name="FreeMemoryGB"
    Expression={[math]::Round($_.FreePhysicalMemory / 1MB, 2)}
}

$Disk = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
Select-Object DeviceID, @{
    Name="SizeGB"
    Expression={[math]::Round($_.Size / 1GB, 2)}
}, @{
    Name="FreeSpaceGB"
    Expression={[math]::Round($_.FreeSpace / 1GB, 2)}
}

@"
SYSTEM HEALTH REPORT
===================
CPU:
$($CPU | Out-String)

MEMORY:
$($Memory | Out-String)

DISK:
$($Disk | Out-String)
"@ | Out-File ".\SystemHealthReport.txt"

Write-Output "System health report generated."
