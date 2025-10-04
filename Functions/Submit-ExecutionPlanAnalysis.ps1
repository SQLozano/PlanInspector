Function Submit-ExecutionPlanAnalysis
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]$VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference'),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Instance = [System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Database = [System.Environment]::GetEnvironmentVariable("PlanInspector_Database","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Schema   = [System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","Machine"),        
        [Parameter(Mandatory=$true)][System.Object]$ExecutionPlans
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

#==================================================================================================
#Create datatable $DtStmtSimple.
#==================================================================================================
Write-Verbose "Creating `$DtStmtSimple" -verbose
$DtStmtSimple = New-Object system.Data.DataTable
[void]$DtStmtSimple.Columns.Add("CapturedPlan_id"                  , "System.int64")
[void]$DtStmtSimple.Columns.Add("id"                               , "System.int64")
[void]$DtStmtSimple.Columns.Add("StatementCompId"                  , "System.int64")
[void]$DtStmtSimple.Columns.Add("StatementEstRows"                 , "System.double")
[void]$DtStmtSimple.Columns.Add("StatementId"                      , "System.int64")
[void]$DtStmtSimple.Columns.Add("QueryCompilationReplay"           , "System.int64")
[void]$DtStmtSimple.Columns.Add("StatementOptmLevel"               , "System.String")
[void]$DtStmtSimple.Columns.Add("StatementOptmEarlyAbortReason"    , "System.String")
[void]$DtStmtSimple.Columns.Add("CardinalityEstimationModelVersion", "System.String")
[void]$DtStmtSimple.Columns.Add("StatementSubTreeCost"             , "System.double")
[void]$DtStmtSimple.Columns.Add("StatementText"                    , "System.String")
[void]$DtStmtSimple.Columns.Add("StatementType"                    , "System.String")
[void]$DtStmtSimple.Columns.Add("TemplatePlanGuideDB"              , "System.String")
[void]$DtStmtSimple.Columns.Add("TemplatePlanGuideName"            , "System.String")
[void]$DtStmtSimple.Columns.Add("PlanGuideDB"                      , "System.String")
[void]$DtStmtSimple.Columns.Add("PlanGuideName"                    , "System.String")
[void]$DtStmtSimple.Columns.Add("ParameterizedText"                , "System.String")
[void]$DtStmtSimple.Columns.Add("ParameterizedPlanHandle"          , "System.String")
[void]$DtStmtSimple.Columns.Add("QueryHash"                        , "Byte[]")
[void]$DtStmtSimple.Columns.Add("QueryPlanHash"                    , "Byte[]")
[void]$DtStmtSimple.Columns.Add("RetrievedFromCache"               , "System.String")
[void]$DtStmtSimple.Columns.Add("StatementSqlHandle"               , "Byte[]")
[void]$DtStmtSimple.Columns.Add("DatabaseContextSettingsId"        , "System.int64")
[void]$DtStmtSimple.Columns.Add("ParentObjectId"                   , "System.int64")
[void]$DtStmtSimple.Columns.Add("BatchSqlHandle"                   , "Byte[]")
[void]$DtStmtSimple.Columns.Add("StatementParameterizationType"    , "System.int64")
[void]$DtStmtSimple.Columns.Add("SecurityPolicyApplied"            , "System.boolean")
[void]$DtStmtSimple.Columns.Add("BatchModeOnRowStoreUsed"          , "System.boolean")
[void]$DtStmtSimple.Columns.Add("QueryStoreStatementHintId"        , "System.int64")
[void]$DtStmtSimple.Columns.Add("QueryStoreStatementHintText"      , "System.String")
[void]$DtStmtSimple.Columns.Add("QueryStoreStatementHintSource"    , "System.String")
[void]$DtStmtSimple.Columns.Add("ContainsLedgerTables"             , "System.boolean")
#==================================================================================================
#Create datatable $DtStatementSetOptions.
#==================================================================================================
Write-Verbose "Creating `$DtStatementSetOptions"
$DtStatementSetOptions = New-Object system.Data.DataTable
[void]$DtStatementSetOptions.Columns.Add("StatementSetOptions_id" , "System.int64")
[void]$DtStatementSetOptions.Columns.Add("CapturedPlan_id"        , "System.int64")
[void]$DtStatementSetOptions.Columns.Add("ANSI_NULLS"             , "System.boolean")
[void]$DtStatementSetOptions.Columns.Add("ANSI_PADDING"           , "System.boolean")
[void]$DtStatementSetOptions.Columns.Add("ANSI_WARNINGS"          , "System.boolean")
[void]$DtStatementSetOptions.Columns.Add("ARITHABORT"             , "System.boolean")
[void]$DtStatementSetOptions.Columns.Add("CONCAT_NULL_YIELDS_NULL", "System.boolean")
[void]$DtStatementSetOptions.Columns.Add("NUMERIC_ROUNDABORT"     , "System.boolean")
[void]$DtStatementSetOptions.Columns.Add("QUOTED_IDENTIFIER"      , "System.boolean")
#==================================================================================================
#Create datatable $DtQueryPlan.
#==================================================================================================
Write-Verbose "Creating `$DtQueryPlan"
$DtQueryPlan = New-Object system.Data.DataTable
[void]$DtQueryPlan.Columns.Add("QueryPlan_id"                          , "System.int64")
[void]$DtQueryPlan.Columns.Add("CapturedPlan_id"                       , "System.int64")
[void]$DtQueryPlan.Columns.Add("DegreeOfParallelism"                   , "System.int64")
[void]$DtQueryPlan.Columns.Add("EffectiveDegreeOfParallelism"          , "System.int64")
[void]$DtQueryPlan.Columns.Add("NonParallelPlanReason"                 , "System.string")
[void]$DtQueryPlan.Columns.Add("DOPFeedbackAdjusted"                   , "System.string")
[void]$DtQueryPlan.Columns.Add("MemoryGrant"                           , "System.int64")
[void]$DtQueryPlan.Columns.Add("CachedPlanSize"                        , "System.int64")
[void]$DtQueryPlan.Columns.Add("CompileTime"                           , "System.int64")
[void]$DtQueryPlan.Columns.Add("CompileCPU"                            , "System.int64")
[void]$DtQueryPlan.Columns.Add("CompileMemory"                         , "System.int64")
[void]$DtQueryPlan.Columns.Add("UsePlan"                               , "System.boolean")
[void]$DtQueryPlan.Columns.Add("ContainsInterleavedExecutionCandidates", "System.boolean")
[void]$DtQueryPlan.Columns.Add("ContainsInlineScalarTsqlUdfs"          , "System.boolean")
[void]$DtQueryPlan.Columns.Add("QueryVariantID"                        , "System.int64")
[void]$DtQueryPlan.Columns.Add("DispatcherPlanHandle"                  , "System.string")
[void]$DtQueryPlan.Columns.Add("ExclusiveProfileTimeActive"            , "System.boolean")
#==================================================================================================
#Create datatable $DtPlanWarnings.
#==================================================================================================
Write-Verbose "Creating `$DtPlanWarnings"
$DtPlanWarnings = New-Object system.Data.DataTable
[void]$DtPlanWarnings.Columns.Add("id"                          , "System.int64")
[void]$DtPlanWarnings.Columns.Add("CapturedPlan_id"             , "System.Int32")
[void]$DtPlanWarnings.Columns.Add("IsColumnsWithNoStatistics"   , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsColumnsWithStaleStatistics", "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsExchangeSpillDetails"      , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsHashSpillDetails"          , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsMemoryGrantWarning"        , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsNoJoinPredicate"           , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsPlanAffectingConvert"      , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsSortSpillDetails"          , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsSpillOccurred"             , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsSpillToTempDb"             , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsUnmatchedIndexes"          , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("IsWait"                      , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("Server"                      , "System.String")
[void]$DtPlanWarnings.Columns.Add("Database"                    , "System.String")
[void]$DtPlanWarnings.Columns.Add("Schema"                      , "System.String")
[void]$DtPlanWarnings.Columns.Add("Table"                       , "System.String")
[void]$DtPlanWarnings.Columns.Add("Alias"                       , "System.String")
[void]$DtPlanWarnings.Columns.Add("Index"                       , "System.String")
[void]$DtPlanWarnings.Columns.Add("Column"                      , "System.String")
[void]$DtPlanWarnings.Columns.Add("ComputedColumn"              , "System.Boolean")
[void]$DtPlanWarnings.Columns.Add("ParameterDataType"           , "System.String")
[void]$DtPlanWarnings.Columns.Add("ParameterCompiledValue"      , "System.String")
[void]$DtPlanWarnings.Columns.Add("ParameterRuntimeValue"       , "System.String")
[void]$DtPlanWarnings.Columns.Add("ConvertIssue"                , "System.String")
[void]$DtPlanWarnings.Columns.Add("Expression"                  , "System.String")
[void]$DtPlanWarnings.Columns.Add("GrantWarningKind"            , "System.string")
[void]$DtPlanWarnings.Columns.Add("RequestedMemory"             , "System.int64")
[void]$DtPlanWarnings.Columns.Add("GrantedMemory"               , "System.int64")
[void]$DtPlanWarnings.Columns.Add("MaxUsedMemory"               , "System.int64")
[void]$DtPlanWarnings.Columns.Add("SpillLevel"                  , "System.int64")
[void]$DtPlanWarnings.Columns.Add("SpilledThreadCount"          , "System.int64")
[void]$DtPlanWarnings.Columns.Add("GrantedMemoryKb"             , "System.int64")
[void]$DtPlanWarnings.Columns.Add("UsedMemoryKb"                , "System.int64")
[void]$DtPlanWarnings.Columns.Add("WritesToTempDb"              , "System.int64")
[void]$DtPlanWarnings.Columns.Add("ReadsFromTempDb"             , "System.int64")
[void]$DtPlanWarnings.Columns.Add("WaitType"                    , "System.string")
[void]$DtPlanWarnings.Columns.Add("WaitTime"                    , "System.int64")
[void]$DtPlanWarnings.Columns.Add("Detail"                      , "System.Boolean")
#==================================================================================================
#Create datatable $DtMissingIndex.
#==================================================================================================
Write-Verbose "Creating `$DtMissingIndex"
$DtMissingIndex = New-Object system.Data.DataTable
[void]$DtMissingIndex.Columns.Add("CapturedPlan_id" , "System.int64")
#==================================================================================================
#Create datatable $DtMemoryGrantInfo.
#==================================================================================================
Write-Verbose "Creating `$DtMemoryGrantInfo"
$DtMemoryGrantInfo = New-Object system.Data.DataTable
[void]$DtMemoryGrantInfo.Columns.Add("id"                           , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("CapturedPlan_id"              , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("SerialRequiredMemory"         , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("SerialDesiredMemory"          , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("RequiredMemory"               , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("DesiredMemory"                , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("RequestedMemory"              , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("GrantWaitTime"                , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("GrantedMemory"                , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("MaxUsedMemory"                , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("MaxQueryMemory"               , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("LastRequestedMemory"          , "System.int64")
[void]$DtMemoryGrantInfo.Columns.Add("IsMemoryGrantFeedbackAdjusted", "System.string")
#==================================================================================================
#Create datatable OptimizerHardwareDependentProperties.
#==================================================================================================
Write-Verbose "Creating `$OptimizerHardwareDependentProperties"
$DtOptimizerHardwareDependentProperties = New-Object system.Data.DataTable
[void]$DtOptimizerHardwareDependentProperties.Columns.Add("id"                                   , "System.int64")
[void]$DtOptimizerHardwareDependentProperties.Columns.Add("CapturedPlan_id"                      , "System.int64")
[void]$DtOptimizerHardwareDependentProperties.Columns.Add("EstimatedAvailableMemoryGrant"        , "System.int64")
[void]$DtOptimizerHardwareDependentProperties.Columns.Add("EstimatedPagesCached"                 , "System.int64")
[void]$DtOptimizerHardwareDependentProperties.Columns.Add("EstimatedAvailableDegreeOfParallelism", "System.int32")
[void]$DtOptimizerHardwareDependentProperties.Columns.Add("MaxCompileMemory"                     , "System.int64")
#==================================================================================================
#Create datatable $DtStatisticsInfo.
#==================================================================================================
Write-Verbose "Creating `$DtStatisticsInfo"
$DtStatisticsInfo = New-Object system.Data.DataTable
[void]$DtStatisticsInfo.Columns.Add("id"               , "System.int64")
[void]$DtStatisticsInfo.Columns.Add("CapturedPlan_id"  , "System.Int32")
[void]$DtStatisticsInfo.Columns.Add("Database"         , "System.String")
[void]$DtStatisticsInfo.Columns.Add("Schema"           , "System.String")
[void]$DtStatisticsInfo.Columns.Add("Table"            , "System.String")
[void]$DtStatisticsInfo.Columns.Add("Statistics"       , "System.String")
[void]$DtStatisticsInfo.Columns.Add("ModificationCount", "System.int64")
[void]$DtStatisticsInfo.Columns.Add("SamplingPercent"  , "System.decimal")
[void]$DtStatisticsInfo.Columns.Add("LastUpdate"       , "System.DateTime")
#==================================================================================================
#Create datatable $DtTraceFlag.
#==================================================================================================
Write-Verbose "Creating `$DtTraceFlag"
$DtTraceFlag = New-Object system.Data.DataTable
[void]$DtTraceFlag.Columns.Add("id"              , "System.int64")
[void]$DtTraceFlag.Columns.Add("CapturedPlan_id" , "System.int64")
[void]$DtTraceFlag.Columns.Add("Value"           , "System.int64")
[void]$DtTraceFlag.Columns.Add("Scope"           , "System.String")
#==================================================================================================
#Create datatable $DtWaitStats.
#==================================================================================================
Write-Verbose "Creating `$DtWaitStats"
$DtWaitStats = New-Object system.Data.DataTable
[void]$DtWaitStats.Columns.Add("id"              , "System.int64")
[void]$DtWaitStats.Columns.Add("CapturedPlan_id" , "System.int64")
[void]$DtWaitStats.Columns.Add("WaitType"        , "System.String")
[void]$DtWaitStats.Columns.Add("WaitTimeMs"      , "System.int64")
[void]$DtWaitStats.Columns.Add("WaitCount"       , "System.int64")
#==================================================================================================
#Create datatable $DtQueryTimeStats.
#==================================================================================================
Write-Verbose "Creating `$DtQueryTimeStats"
$DtQueryTimeStats = New-Object system.Data.DataTable
[void]$DtQueryTimeStats.Columns.Add("id"              , "System.int64")
[void]$DtQueryTimeStats.Columns.Add("CapturedPlan_id" , "System.int64")
[void]$DtQueryTimeStats.Columns.Add("CpuTime"         , "System.int64")
[void]$DtQueryTimeStats.Columns.Add("ElapsedTime"     , "System.int64")
[void]$DtQueryTimeStats.Columns.Add("UdfCpuTime"      , "System.int64")
[void]$DtQueryTimeStats.Columns.Add("UdfElapsedTime"  , "System.int64")
#==================================================================================================
#Create datatable $DtRelop.
#==================================================================================================
Write-Verbose "Creating `$DtRelop"
$DtRelop = New-Object system.Data.DataTable
[void]$DtRelop.Columns.Add("CapturedPlan_id"                               , "System.int64")
[void]$DtRelop.Columns.Add("Relop_id"                                      , "System.int64")
[void]$DtRelop.Columns.Add("AvgRowSize"                                    , "System.double")
[void]$DtRelop.Columns.Add("EstimateCPU"                                   , "System.double")
[void]$DtRelop.Columns.Add("EstimateIO"                                    , "System.double")
[void]$DtRelop.Columns.Add("EstimateRebinds"                               , "System.double")
[void]$DtRelop.Columns.Add("EstimateRewinds"                               , "System.double")
[void]$DtRelop.Columns.Add("EstimatedExecutionMode"                        , "System.String")
[void]$DtRelop.Columns.Add("GroupExecuted"                                 , "System.boolean")
[void]$DtRelop.Columns.Add("EstimateRows"                                  , "System.double")
[void]$DtRelop.Columns.Add("EstimateRowsWithoutRowGoal"                    , "System.double")
[void]$DtRelop.Columns.Add("EstimatedRowsRead"                             , "System.double")
[void]$DtRelop.Columns.Add("LogicalOp"                                     , "System.String")
[void]$DtRelop.Columns.Add("NodeId"                                        , "System.int32")
[void]$DtRelop.Columns.Add("Parallel"                                      , "System.boolean")
[void]$DtRelop.Columns.Add("RemoteDataAccess"                              , "System.boolean")
[void]$DtRelop.Columns.Add("Partitioned"                                   , "System.boolean")
[void]$DtRelop.Columns.Add("PhysicalOp"                                    , "System.String")
[void]$DtRelop.Columns.Add("IsAdaptive"                                    , "System.boolean")
[void]$DtRelop.Columns.Add("AdaptiveThresholdRows"                         , "System.double")
[void]$DtRelop.Columns.Add("EstimatedTotalSubtreeCost"                     , "System.double")
[void]$DtRelop.Columns.Add("TableCardinality"                              , "System.double")
[void]$DtRelop.Columns.Add("StatsCollectionId"                             , "System.int64")
[void]$DtRelop.Columns.Add("EstimatedJoinType"                             , "System.String")
[void]$DtRelop.Columns.Add("HyperScaleOptimizedQueryProcessing"            , "System.String")
[void]$DtRelop.Columns.Add("HyperScaleOptimizedQueryProcessingUnusedReason", "System.String")
[void]$DtRelop.Columns.Add("EstimateNumberOfExecutions"                    , "System.double")
[void]$DtRelop.Columns.Add("EstimateNumberOfRowsForAllExecutions"          , "System.double")
#==================================================================================================
#Create datatable $DtIntermidiateRelop.
#==================================================================================================
Write-Verbose "Creating `$DtIntermidiateRelop"
$DtIntermidiateRelop = $DtRelop.Clone()
#==================================================================================================
#Create datatable $DtRunTimeCountersPerThread.
#==================================================================================================
Write-Verbose "Creating `$DtRunTimeCountersPerThread"
$DtRunTimeCountersPerThread = New-Object system.Data.DataTable
[void]$DtRunTimeCountersPerThread.Columns.Add("CapturedPlan_id"              , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("Relop_id"                     , "System.int64")
[void]$DtRunTimeCountersPerThread.Columns.Add("Thread_id"                    , "System.int64")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualCPUms"                  , "System.Decimal")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualElapsedms"              , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualEndOfScans"             , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualExecutionMode"          , "System.String")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualExecutions"             , "System.Decimal")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualJoinType"               , "System.String")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualLobLogicalReads"        , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualLobPageServerReadAheads", "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualLobPageServerReads"     , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualLobPhysicalReads"       , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualLobReadAheads"          , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualLocallyAggregatedRows"  , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualLogicalReads"           , "System.decimal")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualPageServerPushedPageIDs", "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualPageServerPushedReads"  , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualPageServerReadAheads"   , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualPageServerReads"        , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualPageServerRowsRead"     , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualPageServerRowsReturned" , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualPhysicalReads"          , "System.Decimal")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualReadAheads"             , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualRebinds"                , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualRewinds"                , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualRows"                   , "System.Decimal")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualRowsRead"               , "System.Decimal")
[void]$DtRunTimeCountersPerThread.Columns.Add("ActualScans"                  , "System.Decimal")
[void]$DtRunTimeCountersPerThread.Columns.Add("Batches"                      , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("BrickId"                      , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("CloseTime"                    , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("FirstActiveTime"              , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("FirstRowTime"                 , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("HpcDeviceToHostBytes"         , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("HpcHostToDeviceBytes"         , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("HpcKernelElapsedUs"           , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("HpcRowCount"                  , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("InputMemoryGrant"             , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("IsInterleavedExecuted"        , "System.Boolean")
[void]$DtRunTimeCountersPerThread.Columns.Add("LastActiveTime"               , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("LastRowTime"                  , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("Nodeid"                       , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("OpenTime"                     , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("OutputMemoryGrant"            , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("RowRequalifications"          , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("SchedulerId"                  , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("SegmentReads"                 , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("SegmentSkips"                 , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("TaskAddr"                     , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("Thread"                       , "System.Int32")
[void]$DtRunTimeCountersPerThread.Columns.Add("UsedMemoryGrant"              , "System.Int32")
#==================================================================================================
#Create datatable $DtParameterList.
#==================================================================================================
Write-Verbose "Creating `$DtParameterList"
$DtParameterList = New-Object system.Data.DataTable
[void]$DtParameterList.Columns.Add("id"                    , "System.int64")
[void]$DtParameterList.Columns.Add("CapturedPlan_id"       , "System.int64")
[void]$DtParameterList.Columns.Add("Column"                , "System.String")
[void]$DtParameterList.Columns.Add("ParameterDataType"     , "System.String")
[void]$DtParameterList.Columns.Add("ParameterCompiledValue", "System.String")
[void]$DtParameterList.Columns.Add("ParameterRuntimeValue" , "System.String")
#==================================================================================================
#Create datatable $DtColumnReference.
#==================================================================================================
Write-Verbose "Creating `$DtColumnReference"
$DtColumnReference = New-Object system.Data.DataTable
[void]$DtColumnReference.Columns.Add("ColumnReference_ID"    , "System.int64")
[void]$DtColumnReference.Columns.Add("CapturedPlan_id"       , "System.int64")
[void]$DtColumnReference.Columns.Add("Database"              , "System.String")
[void]$DtColumnReference.Columns.Add("Schema"                , "System.String")
[void]$DtColumnReference.Columns.Add("Table"                 , "System.String")
[void]$DtColumnReference.Columns.Add("Column"                , "System.String")

#==================================================================================================
# Loop through all the elements in the execution plan
#==================================================================================================
foreach($ExecutionPlan in $ExecutionPlans)
{
  try
  {
    $CapturedPlan_id = $ExecutionPlan.CapturedPlan_id
    [Xml]$Plan        = $ExecutionPlan.showplan_xml
    Write-Verbose "Processing `$CapturedPlanID = $($CapturedPlan_id)" 
    #==================================================================================================
    #Write basic statement info to $DtStmtSimple.
    #==================================================================================================
    $XMLElements  = $Plan.GetElementsByTagName('StmtSimple')
    foreach ($XMLElement in $XMLElements)
    {
      Write-Verbose "Loading data into `$DtStmtSimple"
      Write-StmtSimple -DtStmtSimple $DtStmtSimple -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Write StatementSetOptions info to $DtStatementSetOptions.
    #==================================================================================================
    $XMLElement = $Plan.GetElementsByTagName('StatementSetOptions')
    if($XMLElement.Count -gt 0)
    {
      Write-Verbose "Loading data into `$DtStatementSetOptions"
      Write-StatementSetOptions -DtStatementSetOptions $DtStatementSetOptions -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Write Query plan info to $DtQueryPlan.
    #==================================================================================================
    $XMLElements = $Plan.GetElementsByTagName('QueryPlan')
    foreach ($XMLElement in $XMLElements)
    {
      Write-Verbose "Loading data into `$DtQueryPlan"
      Write-QueryPlan -DtQueryPlan $DtQueryPlan -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Write missing indexes info to $DtMissingIndex.
    #==================================================================================================
    $XMLElements  = $Plan.GetElementsByTagName('MissingIndex')
    if($XMLElements.Count -gt 0)
    {
      Write-Verbose "Loading data into `$DtMissingIndex"
      Write-MissingIndex -DtMissingIndex $DtMissingIndex -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Get Warnings from the plan.
    #==================================================================================================
    #####################################################################
    $XMLElements = $Plan.GetElementsByTagName('Warnings')
    if($XMLElements.Count -gt 0)
    {
      Write-Verbose "Loading data into `$DtPlanWarnings"
      Write-Warnings -XMLElement $XMLElements -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Write MemoryGrantInfo to $DtMemoryGrantInfo.
    #==================================================================================================
    $XMLElements = $Plan.GetElementsByTagName('MemoryGrantInfo')
    foreach ($XMLElement in $XMLElements)
    {
      Write-Verbose "Loading data into `$DtMemoryGrantInfo"
      Write-MemoryGrantInfo -DtMemoryGrantInfo $DtMemoryGrantInfo -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Write OptimizerHardwareDependentProperties to $DtOptimizerHardwareDependentProperties.
    #==================================================================================================
    $XMLElements = $Plan.GetElementsByTagName('OptimizerHardwareDependentProperties')
    foreach ($XMLElement in $XMLElements)
    {
      Write-Verbose "Loading data into `$DtOptimizerHardwareDependentProperties"
      Write-OptimizerHardwareDependentProperties -DtOptimizerHardwareDependentProperties $DtOptimizerHardwareDependentProperties -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Write MemoryGrantInfo to $DtStatisticsInfo.
    #==================================================================================================
    $OptimizerStatsUsage = $Plan.GetElementsByTagName('OptimizerStatsUsage') #Make sure that only stats from the OptimizerStatsUsage section are gathered
    if($null -ne $OptimizerStatsUsage.StatisticsInfo)
    {
      $XMLElements = $OptimizerStatsUsage.GetElementsByTagName('StatisticsInfo')
      Write-Verbose "Loading data into `$DtStatisticsInfo"
      foreach ($XMLElement in $XMLElements)
      {
        Write-StatisticsInfo -DtStatisticsInfo $DtStatisticsInfo -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
      }
    }
    #==================================================================================================
    #Write Trace flags to $DtTraceFlag.
    #==================================================================================================
    $XMLElements = $Plan.GetElementsByTagName('TraceFlag')
    foreach ($XMLElement in $XMLElements)
    {
      Write-Verbose "Loading data into `$DtTraceFlag"
      Write-TraceFlags -DtTraceFlag $DtTraceFlag -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Write WaitStats to $DtWaitStats.
    #==================================================================================================
    $XMLElements = $Plan.GetElementsByTagName('WaitStats')
    if($XMLElements.Count -gt 0)
    {
      Write-Verbose "Loading data into `$DtWaitStats"
      Write-WaitStats -DtWaitStats $DtWaitStats -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Write QueryTimeStats to $DtQueryTimeStats.
    #==================================================================================================
    $XMLElements = $Plan.GetElementsByTagName('QueryTimeStats')
    foreach ($XMLElement in $XMLElements)
    {
      Write-Verbose "Loading data into `$DtQueryTimeStats"
      Write-QueryTimeStats -DtQueryTimeStats $DtQueryTimeStats -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id
    }
    #==================================================================================================
    #Write ColumnReference to $DtColumnReference.
    #==================================================================================================
    $XMLElements = $Plan.GetElementsByTagName('ColumnReference')
    Write-Verbose "Loading data into `$DtColumnReference"
    Write-ColumnReference -DtColumnReference $DtColumnReference -XMLElements $XMLElements -CapturedPlan_id $CapturedPlan_id
    #==================================================================================================
    #Write Query plan info to $DtRelop.
    #==================================================================================================
    $XMLElements = $Plan.GetElementsByTagName('RelOp') 
    foreach ($XMLElement in $XMLElements)
    {
      $Relop_id = [int]$XMLElement.NodeId
      Write-Relop DtRelop $DtRelop -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id -Relop_id $Relop_id
      #==================================================================================================
      #Write Thread info to $DtRunTimeCountersPerThread.
      #==================================================================================================                              
      if ($null -ne $XMLElement.RunTimeInformation)
      {
        Write-Verbose "Loading data into `$DtRunTimeCountersPerThread"
        Write-RuntimeInformation -DtRunTimeCountersPerThread $DtRunTimeCountersPerThread -XMLElement $XMLElement -CapturedPlan_id $CapturedPlan_id -Relop_id $Relop_id
      }
    }
    #For nested loop joins, the value for 'Estimated Number Of Rows For AllExecutions' isn't in the execution plan
    #to obtain this number of rows read (Estimated Number Of Rows For AllExecutions) should be multiplied by the estimated
    $XMLElements = $Plan.GetElementsByTagName('NestedLoops')
    if($null -ne $XMLElements)
    {
      Write-Verbose "Getting information from NestedLoopInfo operations"
      Write-NestedLoopInfo -XMLElements $XMLElements -CapturedPlan_id $CapturedPlan_id -Relop_id $Relop_id
    }
    #==================================================================================================
    #Write info from Intermediate table DtIntermidiateRelop to $DtRelop and clear $DtIntermidiateRelop.
    #==================================================================================================   
    <#Data is initially written to an 'Intermediate table'. When writing the nested loop info, data must be updated. 
      When searching in a large datatable, this really slows down the process and then it makes sense to use an intermidate table. #>
    foreach ($Row in $DtIntermidiateRelop)
    {
      [void]$DtRelop.ImportRow($Row)
    }
    $DtIntermidiateRelop.Clear()
    #==================================================================================================
    #Write ParamterList to $DtParameterList.
    #==================================================================================================   
    $XMLElements =  $Plan.GetElementsByTagName('ParameterList') | Where-object {$PsItem.ColumnReference -ne $null} | Select-Object -ExpandProperty ColumnReference
    if($null -ne $XMLElements)
    {
      Write-Verbose "Loading data into `$DtParameterList"
      Write-ParameterList -DtParameterList $DtParameterList -XMLElements $XMLElements -CapturedPlan_id $CapturedPlan_id
    }
  }
  catch
  {
    $Error[0] | Format-List -force
    throw
  }
}

#==================================================================================================
# Load the contents of all $DTs into the database
#==================================================================================================   
Write-Verbose "Loading `$DtMemoryGrantInfo into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[MemoryGrantInfo]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "MemoryGrantInfo" -InputData $DtMemoryGrantInfo -Timeout 60
Write-Verbose "Loading `$DtMissingIndex into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[MissingIndex]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "MissingIndex" -InputData $DtMissingIndex -Timeout 60
Write-Verbose "Loading `$DtOptimizerHardwareDependentProperties into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[DtOptimizerHardwareDependentProperties]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "OptimizerHardwareDependentProperties" -InputData $DtOptimizerHardwareDependentProperties -Timeout 60
Write-Verbose "Loading `$DtParameterList into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[ParameterList]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "ParameterList" -InputData $DtParameterList -Timeout 60
Write-Verbose "Loading `$DtPlanWarning into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[PlanWarning]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "Warning" -InputData $DtPlanWarnings -Timeout 60
Write-Verbose "Loading `$DtQueryPlan into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[QueryPlan]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "QueryPlan" -InputData $DtQueryPlan -Timeout 60
Write-Verbose "Loading `$DtQueryTimeStats into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[QueryTimeStats]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "QueryTimeStats" -InputData $DtQueryTimeStats -Timeout 60
Write-Verbose "Loading `$DtRelop into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[Relop]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "Relop" -InputData $DtRelop -Timeout 60
Write-Verbose "Loading `$DtRunTimeCountersPerThread into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[RunTimeCountersPerThread]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "RunTimeCountersPerThread" -InputData $DtRunTimeCountersPerThread -Timeout 60
Write-Verbose "Loading `$DtStatementSetOptions into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[StatementSetOptions]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "StatementSetOptions" -InputData $DtStatementSetOptions -Timeout 60
Write-Verbose "Loading `$DtStatisticsInfo into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[StatisticsInfo]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "StatisticsInfo" -InputData $DtStatisticsInfo -Timeout 60
Write-Verbose "Loading `$DtStmtSimple into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[StmtSimple]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "StmtSimple" -InputData $DtStmtSimple -Timeout 60
Write-Verbose "Loading `$DtTraceFlag into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[TraceFlag]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "TraceFlag" -InputData $DtTraceFlag -Timeout 60
Write-Verbose "Loading `$DtWaitStats into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[WaitStats]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "WaitStats" -InputData $DtWaitStats -Timeout 60
Write-Verbose "Loading `$DtColumnReference into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[ColumnReference]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "ColumnReference" -InputData $DtColumnReference -Timeout 60


Compress-ExecutionPlan -CapturedPlan_id $CapturedPlan_id


# Write-Verbose "Loading `$DtWaitStats into [$PlanInspector_Instance].[$PlanInspector_Database].[$PlanInspector_Schema].[xxxxx]"
# Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName "xxxxx" -InputData $xxxxx
}