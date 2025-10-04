#==================================================================================================
#Function: Write Basic statement information to $DtStmtSimple
#==================================================================================================
function Write-StmtSimple ([System.Data.DataTable]$DtStmtSimple, $Element, $CapturedPlan_id)
{
  [void]$DtStmtSimple.Rows.Add($null, $CapturedPlan_id,$Element.StatementCompId,[double]$Element.StatementEstRows,$Element.StatementId,$Element.QueryCompilationReplay,
                              $Element.StatementOptmLevel, $Element.StatementOptmEarlyAbortReason, $Element.CardinalityEstimationModelVersion,
                              [double]$Element.StatementSubTreeCost, $Element.StatementText, $Element.StatementType,$Element.TemplatePlanGuideDB,
                              $Element.TemplatePlanGuideName, $Element.PlanGuideDB, $Element.PlanGuideName, $Element.ParameterizedText,
                              $Element.ParameterizedPlanHandle, $Element.QueryHash, $Element.QueryPlanHash, $Element.RetrievedFromCache,
                              $Element.StatementSqlHandle, $Element.DatabaseContextSettingsId, $Element.ParentObjectId,$Element.BatchSqlHandle,
                              $Element.StatementParameterizationType, [System.Boolean]$Element.SecurityPolicyApplied,
                              [System.Boolean]$Element.BatchModeOnRowStoreUsed,$Element.QueryStoreStatementHintId,$Element.QueryStoreStatementHintText,
                              $Element.QueryStoreStatementHintSource, [System.Boolean]$Element.ContainsLedgerTables)           
} 