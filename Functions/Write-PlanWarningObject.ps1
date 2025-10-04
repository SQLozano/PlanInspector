#==================================================================================================
#Function: Write plan warning with a object reference to a $Dt ('UnmatchedIndexes')
#==================================================================================================
function Write-PlanWarningObject  ($XMLElement, $DtPlanWarnings, $CapturedPlan_id, $WarningName)
{
  $Objects = $XMLElement.GetElementsByTagName('Object')
  foreach($Object in $Objects)
  {
    $arrayrow                     = $DtPlanWarnings.NewRow()
    $arrayrow["id"]               = [DBNull]::Value
    $arrayrow["CapturedPlan_id"] = $CapturedPlan_id  
    try 
    {
      $arrayrow["Server"]   = Test-Null $Object.Server
      $arrayrow["Database"] = Test-Null $Object.Database
      $arrayrow["Schema"]   = Test-Null $Object.Schema
      $arrayrow["Table"]    = Test-Null $Object.Table       
      $arrayrow["Index"]    = Test-Null $Object.Index
    }
    catch 
    {
      throw
    }
    $KeyName            = ('Is' + $WarningName)
    $arrayrow[$keyName] = $true
    [void]$DtPlanWarnings.Rows.Add($arrayrow)
  }
} 