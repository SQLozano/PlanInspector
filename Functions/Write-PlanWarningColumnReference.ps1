#==================================================================================================
#Function: Write plan warning with a column reference to a $Dt ('ColumnsWithNoStatistics')
#==================================================================================================
function Write-PlanWarningColumnReference  ($XMLElement, $DtPlanWarnings, $CapturedPlan_id, $WarningName)
{
  $ColumnReferences = $XMLElement.GetElementsByTagName('ColumnReference')
  foreach($ColumnReference in $ColumnReferences)
  {
    $arrayrow                     = $DtPlanWarnings.NewRow()
    $arrayrow["id"]               = [DBNull]::Value
    $arrayrow["CapturedPlan_id"] = $CapturedPlan_id  
    try 
    {
      $arrayrow["Database"] = Test-Null $ColumnReference.Database
      $arrayrow["Schema"]   = Test-Null $ColumnReference.Schema
      $arrayrow["Table"]    = Test-Null $ColumnReference.Table       
      $arrayrow["Alias"]    = Test-Null $ColumnReference.Alias
      $arrayrow["Column"]   = $ColumnReference.Column.Replace('[','').Replace(']','') #is required, no need for testing
      
      if($null -ne $ColumnReference.ComputedColumn)
      {
        $arrayrow["ComputedColumn"] = $ColumnReference.ComputedColumn
      }
      else 
      {
        $arrayrow["ComputedColumn"] = [DBNull]::Value
      }
      $arrayrow["ParameterDataType"]      = $ColumnReference.ParameterDataType
      $arrayrow["ParameterCompiledValue"] = $ColumnReference.ParameterCompiledValue
      $arrayrow["ParameterRuntimeValue"]  = $ColumnReference.ParameterRuntimeValue
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