Function Remove-PlanInspectorDatabaseObjects
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]$VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference'),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Instance = [System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Database = [System.Environment]::GetEnvironmentVariable("PlanInspector_Database","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Schema   = [System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","Machine")
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
IF($MissingVariable){
    Write-Output "Required parameters were missing" -ForegroundColor Red
    Write-Output "Check error messages above to fix the issue" -ForegroundColor Red
}



$DropStoredProcedures = "-- DROP PROCEDURE IF EXISTS [{@Schema}].[xxxxxxxx]
DROP PROCEDURE IF EXISTS [{@Schema}].[CompressData]
DROP PROCEDURE IF EXISTS [{@Schema}].[CompressDataAll]
"
$DropStoredProcedures = ($DropStoredProcedures.Replace("{@Schema}",$($PlanInspector_Schema)))
Write-Verbose "Dropping stored procedures"
Write-Verbose $DropStoredProcedures
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $DropStoredProcedures @EncryptionParameter

$DropFunctions = "-- DROP FUNCTION IF EXISTS [{@Schema}].[xxxxxxxx]
"
$DropFunctions = ($DropFunctions.Replace("{@Schema}",$($PlanInspector_Schema)))
Write-Verbose "Dropping functions"
Write-Verbose $DropFunctions
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $DropFunctions @EncryptionParameter

$DropViews = "-- DROP VIEW IF EXISTS [{@Schema}].[xxxxxxxx]
DROP VIEW IF EXISTS [{@Schema}].[vw_Actual]
DROP VIEW IF EXISTS [{@Schema}].[vw_CapturedPlan]
DROP VIEW IF EXISTS [{@Schema}].[vw_Compile_TimeOut]
DROP VIEW IF EXISTS [{@Schema}].[vw_Converted_Plan]
DROP VIEW IF EXISTS [{@Schema}].[vw_Duration]
DROP VIEW IF EXISTS [{@Schema}].[vw_Hashes]
DROP VIEW IF EXISTS [{@Schema}].[vw_Memory_PercentUsed]
DROP VIEW IF EXISTS [{@Schema}].[vw_MemoryGrantFeedbackAdjusted]
DROP VIEW IF EXISTS [{@Schema}].[vw_Missing_Index]
DROP VIEW IF EXISTS [{@Schema}].[vw_Multiple_Plans_Per_QueryHash]
DROP VIEW IF EXISTS [{@Schema}].[vw_NonParallelPlanReason]
DROP VIEW IF EXISTS [{@Schema}].[vw_Parallel_Skew]
DROP VIEW IF EXISTS [{@Schema}].[vw_ParameterList]
DROP VIEW IF EXISTS [{@Schema}].[vw_ParameterListCompiled]
DROP VIEW IF EXISTS [{@Schema}].[vw_ParameterListRuntime]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_ColumnsWithNoStatistics]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_ColumnsWithStaleStatistics]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_ExchangeSpillDetails]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_HashSpillDetails]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_MemoryGrantWarning]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_NoJoinPredicate]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_Overview]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_PlanAffectingConvert]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_SortSpillDetails]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_SpillToTempDb]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_UnmatchedIndexes]
DROP VIEW IF EXISTS [{@Schema}].[vw_PlanWarning_Wait]
DROP VIEW IF EXISTS [{@Schema}].[vw_QueryWithUdf]
DROP VIEW IF EXISTS [{@Schema}].[vw_Statistics_Not_Updated_Last_7_Days]
DROP VIEW IF EXISTS [{@Schema}].[vw_TraceFlag]
"
$DropViews = ($DropViews.Replace("{@Schema}",$($PlanInspector_Schema)))
Write-Verbose "Dropping views"
Write-Verbose $DropViews
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $DropViews @EncryptionParameter


$DropIndexes = "--DROP INDEX IF EXISTS [yyyyyyyy] ON [{@Schema}].[xxxxxxxx]
"
$DropIndexes = ($DropIndexes.Replace("{@Schema}",$($PlanInspector_Schema)))
Write-Verbose "Dropping indexes"
Write-Verbose $DropIndexes
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $DropIndexes @EncryptionParameter

$DropConstraints = "--ALTER TABLE [{@Schema}].[yyyyyyyy] DROP CONSTRAINT [yyyyyyyy]
ALTER TABLE [{@Schema}].[ColumnReference] DROP CONSTRAINT [PK_ColumnReference]
ALTER TABLE [{@Schema}].[ColumnReference] DROP CONSTRAINT [FK_ColumnReference_CapturedPlan_id]
ALTER TABLE [{@Schema}].[MemoryGrantInfo] DROP CONSTRAINT [PK_MemoryGrantInfo]
ALTER TABLE [{@Schema}].[MemoryGrantInfo] DROP CONSTRAINT [FK_MemoryGrantInfo_CapturedPlan_id]
ALTER TABLE [{@Schema}].[MemoryGrantInfo] DROP CONSTRAINT [CK_IsMemoryGrantFeedbackAdjusted]
ALTER TABLE [{@Schema}].[MissingIndex] DROP CONSTRAINT [PK_MissingIndex]
ALTER TABLE [{@Schema}].[MissingIndex] DROP CONSTRAINT [FK_MissingIndex_CapturedPlan_id]
ALTER TABLE [{@Schema}].[OptimizerHardwareDependentProperties] DROP CONSTRAINT [PK_OptimizerHardwareDependentProperties]
ALTER TABLE [{@Schema}].[OptimizerHardwareDependentProperties] DROP CONSTRAINT [FK_OptimizerHardwareDependentProperties_CapturedPlan_id]
ALTER TABLE [{@Schema}].[ParameterList] DROP CONSTRAINT [PK_ParameterList]
ALTER TABLE [{@Schema}].[ParameterList] DROP CONSTRAINT [FK_ParameterList_CapturedPlan_id]
ALTER TABLE [{@Schema}].[QueryPlan] DROP CONSTRAINT [PK_QueryPlan]
ALTER TABLE [{@Schema}].[QueryPlan] DROP CONSTRAINT [FK_QueryPlan_CapturedPlan_id]
ALTER TABLE [{@Schema}].[QueryTimeStats] DROP CONSTRAINT [PK_QueryTimeStats]
ALTER TABLE [{@Schema}].[QueryTimeStats] DROP CONSTRAINT [FK_QueryTimeStats_CapturedPlan_id]
ALTER TABLE [{@Schema}].[RunTimeCountersPerThread] DROP CONSTRAINT [PK_RunTimeCountersPerThread]
ALTER TABLE [{@Schema}].[RunTimeCountersPerThread] DROP CONSTRAINT [FK_RunTimeCountersPerThread_Relop_id]
ALTER TABLE [{@Schema}].[RunTimeCountersPerThread] DROP CONSTRAINT [FK_RunTimeCountersPerThread_CapturedPlan_id]
ALTER TABLE [{@Schema}].[RunTimeCountersPerThread] DROP CONSTRAINT [CK_RunTimeCountersPerThread_ActualExecutionMode]
ALTER TABLE [{@Schema}].[Relop] DROP CONSTRAINT [PK_Relop]
ALTER TABLE [{@Schema}].[Relop] DROP CONSTRAINT [FK_Relop_CapturedPlan_id]
ALTER TABLE [{@Schema}].[StatementSetOptions] DROP CONSTRAINT [PK_StatementSetOptions]
ALTER TABLE [{@Schema}].[StatementSetOptions] DROP CONSTRAINT [FK_StatementSetOptions_CapturedPlan_id]
ALTER TABLE [{@Schema}].[StatisticsInfo] DROP CONSTRAINT [PK_StatisticsInfo]
ALTER TABLE [{@Schema}].[StatisticsInfo] DROP CONSTRAINT [FK_StatisticsInfo_CapturedPlan_id]
ALTER TABLE [{@Schema}].[StmtSimple] DROP CONSTRAINT [PK_StmtSimple]
ALTER TABLE [{@Schema}].[StmtSimple] DROP CONSTRAINT [FK_StmtSimple_CapturedPlan_id]
ALTER TABLE [{@Schema}].[TraceFlag] DROP CONSTRAINT [PK_TraceFlag]
ALTER TABLE [{@Schema}].[TraceFlag] DROP CONSTRAINT [FK_TraceFlag_CapturedPlan_id]
ALTER TABLE [{@Schema}].[WaitStats] DROP CONSTRAINT [PK_WaitStat]
ALTER TABLE [{@Schema}].[WaitStats] DROP CONSTRAINT [FK_WaitStat_CapturedPlan_id]
ALTER TABLE [{@Schema}].[Warning] DROP CONSTRAINT [PK_Warning]
ALTER TABLE [{@Schema}].[Warning] DROP CONSTRAINT [FK_Warning_CapturedPlan_id]
--
ALTER TABLE [{@Schema}].[CapturedPlan] DROP CONSTRAINT [PK_CapturedPlan]
"
$DropConstraints = ($DropConstraints.Replace("{@Schema}",$($PlanInspector_Schema)))
Write-Verbose "Dropping constraints"
Write-Verbose $DropConstraints
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $DropConstraints @EncryptionParameter

$DropTables = "--DROP TABLE IF EXISTS [{@Schema}].[xxxxxxxx]
DROP TABLE IF EXISTS [{@Schema}].[CapturedPlan];
DROP TABLE IF EXISTS [{@Schema}].[ColumnReference];
DROP TABLE IF EXISTS [{@Schema}].[MemoryGrantInfo];
DROP TABLE IF EXISTS [{@Schema}].[MissingIndex];
DROP TABLE IF EXISTS [{@Schema}].[OptimizerHardwareDependentProperties];
DROP TABLE IF EXISTS [{@Schema}].[ParameterList];
DROP TABLE IF EXISTS [{@Schema}].[QueryPlan];
DROP TABLE IF EXISTS [{@Schema}].[QueryTimeStats];
DROP TABLE IF EXISTS [{@Schema}].[Relop];
DROP TABLE IF EXISTS [{@Schema}].[RuntimeCountersPerThread];
DROP TABLE IF EXISTS [{@Schema}].[StatementSetOptions];
DROP TABLE IF EXISTS [{@Schema}].[StatisticsInfo];
DROP TABLE IF EXISTS [{@Schema}].[StmtSimple];
DROP TABLE IF EXISTS [{@Schema}].[StmtSimple_staging];
DROP TABLE IF EXISTS [{@Schema}].[TraceFlag];
DROP TABLE IF EXISTS [{@Schema}].[WaitStats];
DROP TABLE IF EXISTS [{@Schema}].[Warning];
"
$DropTables = ($DropTables.Replace("{@Schema}",$($PlanInspector_Schema)))
Write-Verbose "Dropping tables"
Write-Verbose $DropTables
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $DropTables @EncryptionParameter

$DropSchema = "IF ('{@Schema}' != 'dbo')
    EXEC('DROP SCHEMA [{@Schema}]')
"
$DropSchema = ($DropSchema.Replace("{@Schema}",$($PlanInspector_Schema)))
Write-Verbose "Dropping schema"
Write-Verbose $DropSchema
Invoke-SqlCmd -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -Query $DropSchema @EncryptionParameter

}