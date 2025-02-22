Clear-Host
Get-Date
$TotalStart = Get-Date
$ScriptStart = Get-Date
#==================================================================================================
#Start Build-Database.ps1
#==================================================================================================
Write-Output "Start Build-Database.ps1"
.\PowerShellScripts\Build-Database.ps1 | Out-Null
Write-Output ("End Build-Database.ps1`nScript duration: " + (New-TimeSpan -Start $ScriptStart -End (Get-Date) | Select-Object -ExpandProperty totalSeconds))
$ScriptStart = Get-Date
#==================================================================================================
#Start Import-Xel.ps1
#==================================================================================================
Write-Output "`nStart Import-Xel.ps1"
.\PowerShellScripts\Import-Xel.ps1 | Out-Null
Write-Output ("End Import-Xel.ps1`nScript duration: " + (New-TimeSpan -Start $ScriptStart -End (Get-Date) | Select-Object -ExpandProperty totalSeconds))
$ScriptStart = Get-Date
#==================================================================================================
#Start Write-Data.ps1
#==================================================================================================
Write-Output "`nStart Write-Data.ps1"
.\PowerShellScripts\Write-Data.ps1 | Out-Null
Write-Output ("End Write-Data.ps1`nScript duration: " + (New-TimeSpan -Start $ScriptStart -End (Get-Date) | Select-Object -ExpandProperty totalSeconds))
New-TimeSpan -Start $TotalStart -End (Get-Date) | Select-Object -Property totalSeconds | Format-List