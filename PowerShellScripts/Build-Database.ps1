#==================================================================================================
#Read variables from xml file
#==================================================================================================
try
{
  $XmlLocation    = ".\PowerShellScripts\Variables.xml"
  [xml]$Variables = Get-Content $XmlLocation -ErrorAction Stop
  $ServerName     = $Variables.General.ServerName
  $DbName         = $Variables.General.DbName
  $DDLFile        = $Variables.General.DDLFile
}
catch
{
  $Error[0] | Format-List -force
  Throw
}
$StartTime = Get-Date

#==================================================================================================
#Drop and create output database.
#==================================================================================================
$Query ="
IF EXISTS (SELECT * FROM sys.databases WHERE [name] = '$DbName')
BEGIN
  ALTER DATABASE [$DbName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
  DROP DATABASE  [$DbName];
END;
CREATE DATABASE [$DbName];
ALTER DATABASE  [$DbName] SET RECOVERY SIMPLE WITH NO_WAIT;"
try 
{
  Invoke-SqlCmd -TrustServerCertificate -ServerInstance $ServerName -Database master -Query $Query -ErrorAction Stop
}
catch 
{
  $Error[0] | Format-List -force
  Throw
}
#==================================================================================================
#Execute the create script.  
#==================================================================================================
try
{
  Invoke-SqlCmd -TrustServerCertificate -ServerInstance $ServerName -Database $DbName -InputFile $DDLFile -ErrorAction Stop 
}
catch 
{
  $Error[0] | Format-List -force
  Throw
}
#==================================================================================================
#End of general script
#==================================================================================================
$EndTime = Get-Date
New-TimeSpan -Start $StartTime -End $EndTime | Select-Object -Property totalminutes, totalSeconds | Format-List
Write-Output "End of script."