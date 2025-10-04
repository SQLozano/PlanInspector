#==================================================================================================
#Function: Write plan warning to $Dt
#==================================================================================================
function Write-PlanWarning ($XMLElement, $DtPlanWarnings, $CapturedPlan_id, $WarningName)
{
  $arrayrow                     = $DtPlanWarnings.NewRow()
  $arrayrow["id"]               = [DBNull]::Value
  $arrayrow["CapturedPlan_id"] = $CapturedPlan_id  
  foreach ($key in $XMLElement.Attributes)
  {
    try 
    {
      $arrayrow[$key.Name] = $key.Value
    }
    catch 
    {
      throw
    }
  }
  $KeyName            = ('Is' + $WarningName)
  $arrayrow[$keyName] = $true
  [void]$DtPlanWarnings.Rows.Add($arrayrow)
}