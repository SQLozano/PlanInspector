#==================================================================================================
#Function: Write query plan information to $DtTraceFlag
#==================================================================================================
function Write-TraceFlags ([System.Data.DataTable]$DtTraceFlag,$Elements,$CapturedPlan_id)
{
  foreach ($Element in $Elements.ChildNodes)
  {
    [void]$DtTraceFlag.Rows.Add($null, $CapturedPlan_id, $XMLElement.Value, $XMLElement.Scope)
  }
}