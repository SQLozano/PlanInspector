Function Compress-ExecutionPlan
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]$VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference'),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Instance = [System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Database = [System.Environment]::GetEnvironmentVariable("PlanInspector_Database","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Schema   = [System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","Machine"),        
        [Parameter(Mandatory=$false)][string]$PlanInspector_Table    = [System.Environment]::GetEnvironmentVariable("PlanInspector_Table","Machine"),
        [Parameter(Mandatory=$true)][int32]$CapturedPlan_id
    )
Import-Module SqlServer
# For versions >= 22 of the SqlServer PS module, the default encryption changed so it must be manually set Encrypt
if( (Get-Module -Name "sqlserver").Version.Major -ge 22){
    Write-Verbose "Version of the SQLServer module >= 22, so using '-Encrypt Optional' for SQL connections"
    $EncryptionParameter = @{Encrypt = "Optional"}
}
IF(!$PlanInspector_Instance){
    Write-Output "No value for PlanInspector_Instance was provided" -ForegroundColor Yellow
    Write-Output "Either use the parameter -PlanInspector_Instance when execution this function," -ForegroundColor Yellow
    Write-Output "or set the environment variable with the function 'Set-PlanInspectorVariable -PlanInspector_Database xxxxxxxx'" -ForegroundColor Yellow
    $MissingVariable = 1
}
IF(!$PlanInspector_Database){
    Write-Output "No value for PlanInspector_Database was provided" -ForegroundColor Yellow
    Write-Output "Either use the parameter -PlanInspector_Database when execution this function," -ForegroundColor Yellow
    Write-Output "or set the environment variable with the function 'Set-PlanInspectorVariable -PlanInspector_Database xxxxxxxx'" -ForegroundColor Yellow
    $MissingVariable = 1
}
IF(!$PlanInspector_Schema){
    Write-Output "No value for PlanInspector_Schema was provided" -ForegroundColor Yellow
    Write-Output "Either use the parameter -PlanInspector_Schema when execution this function," -ForegroundColor Yellow
    Write-Output "or set the environment variable with the function 'Set-PlanInspectorVariable -PlanInspector_Schema xxxxxxxx'" -ForegroundColor Yellow
    $MissingVariable = 1
}


Write-Verbose "Compressing execution plan & text for @CapturedPlan_id = $($CapturedPlan_id)"
$CompressData = "UPDATE [{@Schema}].[CapturedPlan]
SET [showplan_xml_compressed] = COMPRESS([showplan_xml])
,[sql_text_compressed] = COMPRESS([sql_text])
WHERE [CapturedPlan_id] = {@CapturedPlan_id}"
$CompressData = ($CompressData.Replace("{@Schema}","$($PlanInspector_Schema)"))
$CompressData = ($CompressData.Replace("{@CapturedPlan_id}","$($CapturedPlan_id)"))
Write-Verbose $CompressData
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $CompressData @EncryptionParameter

Write-Verbose "Deleting uncompressing execution plan & text for @CapturedPlan_id = $($CapturedPlan_id)"
$DeleteUncompressedData = "UPDATE [{@Schema}].[CapturedPlan]
SET [showplan_xml] = NULL
,[sql_text] = NULL
WHERE [CapturedPlan_id] = {@CapturedPlan_id}"
$DeleteUncompressedData = ($DeleteUncompressedData.Replace("{@Schema}","$($PlanInspector_Schema)"))
$DeleteUncompressedData = ($DeleteUncompressedData.Replace("{@CapturedPlan_id}","$($CapturedPlan_id)"))
Write-Verbose $DeleteUncompressedData
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $DeleteUncompressedData @EncryptionParameter

Write-Verbose "Mark @CapturedPlan_id = $($CapturedPlan_id) as processed"
$ProcessedPlan = "UPDATE [{@Schema}].[CapturedPlan]
SET [processed] = 1
WHERE [CapturedPlan_id] = {@CapturedPlan_id}"
$ProcessedPlan = ($ProcessedPlan.Replace("{@Schema}","$($PlanInspector_Schema)"))
$ProcessedPlan = ($ProcessedPlan.Replace("{@CapturedPlan_id}","$($CapturedPlan_id)"))
Write-Verbose $ProcessedPlan
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $ProcessedPlan @EncryptionParameter
}