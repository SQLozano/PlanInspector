#==================================================================================================
#Function: Write query plan information to $DtQueryPlan
#==================================================================================================
function Write-QueryTimeStats ([System.Data.DataTable]$DtQueryTimeStats,$Element,$CapturedPlan_id)
{
  [void]$DtQueryTimeStats.Rows.Add($null, $CapturedPlan_id,$Element.CpuTime, $Element.ElapsedTime, $Element.UdfCpuTime, $Element.UdfElapsedTime)
}  