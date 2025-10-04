#==================================================================================================
#Function: Write warnings
#==================================================================================================
function Write-Warnings ($XMLElements, $CapturedPlan_id)
{
  foreach ($XMLElement in $XMLElements.ChildNodes)
  {
    Switch ($XMLElement.Name)
    {
        'ColumnsWithNoStatistics'    {Write-PlanWarningColumnReference -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id  $CapturedPlan_id -WarningName 'ColumnsWithNoStatistics';break}
        'ColumnsWithStaleStatistics' {Write-PlanWarning -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'ColumnsWithStaleStatistics' ;break}
        'ExchangeSpillDetails'       {Write-PlanWarning -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'ExchangeSpillDetails' ;break}
        'HashSpillDetails'           {Write-PlanWarning -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'HashSpillDetails'; break}
        'MemoryGrantWarning'         {Write-PlanWarning -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'MemoryGrantWarning';break}
        'PlanAffectingConvert'       {Write-PlanWarning -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'PlanAffectingConvert';break}
        'SortSpillDetails'           {Write-PlanWarning -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'SortSpillDetails';break}
        'SpillToTempDb'              {Write-PlanWarning -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'SpillToTempDb';break}
        'Wait'                       {Write-PlanWarning -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'Wait';break}
        'SpillOccurred'              {Write-PlanWarning -XMLElement $XMLElement -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'SpillOccurred';break}
        default                      {Write-Output "$CapturedPlan_id  Check warning $($XMLElement.Name)";throw} 
    }
  }
  if ($XMLElements.NoJoinPredicate -eq 1)
  {
    $arrayrow                     = $DtPlanWarnings.NewRow()
    $arrayrow["id"]               = [DBNull]::Value
    $arrayrow["CapturedPlan_id"] = $CapturedPlan_id  
    $KeyName                      = ('IsNoJoinPredicate')
    $arrayrow[$keyName]           = $true
    [void]$DtPlanWarnings.Rows.Add($arrayrow)
  }
  if ($XMLElements.UnmatchedIndexes -eq 1)
  {
    $UnmatchedIndexes = $Plan.GetElementsByTagName('UnmatchedIndexes')
    foreach ($UnmatchedIndex in $UnmatchedIndexes)
    { 
      #the element type that we're looking for with unmatched indexes = ObjectType
      Write-PlanWarningObject -XMLElement $UnmatchedIndex -DtPlanWarnings $DtPlanWarnings -CapturedPlan_id $CapturedPlan_id -WarningName 'UnmatchedIndexes'
    }
  }
  elseif (($XMLElements.SpatialGuess -eq 1) -or ($XMLElements.FullUpdateForOnlineIndexBuild -eq 1))
  {
    Write-Error 'check the warnings section of this plan'
  }
}