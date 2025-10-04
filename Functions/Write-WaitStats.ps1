#==================================================================================================
#Function: Write query plan information to $DtWaitStats
#==================================================================================================
function Write-WaitStats ([System.Data.DataTable]$DtWaitStats,$Elements,$CapturedPlan_id)
{
  foreach ($Element in $Elements.ChildNodes)
  {
    [void]$DtWaitStats.Rows.Add($null, $CapturedPlan_id,$Element.WaitType, $Element.WaitTimeMs, $Element.WaitCount)
  }
}