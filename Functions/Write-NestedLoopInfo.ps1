#==================================================================================================
#Function: Adjust estimate values in $DtRelop
#==================================================================================================
function Write-NestedLoopInfo ($XMLElements, $CapturedPlan_id)
{
  foreach($XMLElement in $XMLElements)
  {
    #for a nested loop operator the estimated values must be calculated. 
    $IdRelop2                                  = $XMLElement.Relop[1].NodeId
    [decimal]$EstimateNrOfExecutions           = $XMLElement.Relop[0].EstimateRows #estimated nr of rows returned by the top input
    [decimal]$EstimateRows                     = $XMLElement.Relop[1].EstimateRows #estimated nr of rows returned by the bottom inut
    [decimal]$EstimateNrOfRowsForAllExecutions = $EstimateNrOfExecutions * $EstimateRows 
    $DtIntermidiateRelop | Where-Object {($PsItem.CapturedPlan_id -eq $CapturedPlan_id) -and ($PsItem.nodeid -eq $IdRelop2)} | ForEach-Object {$PSItem.EstimateNumberOfExecutions = $EstimateNrOfExecutions} | Out-Null
    $DtIntermidiateRelop | Where-Object {($PsItem.CapturedPlan_id -eq $CapturedPlan_id) -and ($PsItem.nodeid -eq $IdRelop2)} | ForEach-Object {$PSItem.EstimateNumberOfRowsForAllExecutions = $EstimateNrOfRowsForAllExecutions}
  }
}