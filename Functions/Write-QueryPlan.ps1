#==================================================================================================
#Function: Write query plan information to $DtQueryPlan
#==================================================================================================
function Write-QueryPlan ([System.Data.DataTable]$DtQueryPlan, $Element, $CapturedPlan_id)
{
  [void]$DtQueryPlan.Rows.Add($null,$CapturedPlan_id,$Element.DegreeOfParallelism, $Element.EffectiveDegreeOfParallelism, $Element.NonParallelPlanReason,
                              $Element.DOPFeedbackAdjusted, $Element.MemoryGrant, $Element.CachedPlanSize, $Element.CompileTime,
                              $Element.CompileCPU, $Element.CompileMemory, [System.boolean]$Element.UsePlan, [System.boolean]$Element.ContainsInterleavedExecutionCandidates,
                              [System.boolean]$Element.ContainsInlineScalarTsqlUdfs, $Element.QueryVariantID, $Element.DispatcherPlanHandle, [System.boolean]$Element.ExclusiveProfileTimeActive)
} 