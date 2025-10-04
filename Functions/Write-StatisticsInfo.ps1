#==================================================================================================
#Function: Write query plan information to $DtMemoryGrantInfo
#==================================================================================================
function Write-StatisticsInfo ([System.Data.DataTable]$DtStatisticsInfo,$Element,$CapturedPlan_id)
{
  [void]$DtStatisticsInfo.Rows.Add($null, $CapturedPlan_id,$Element.Database, $Element.Schema, $Element.Table,$Element.Statistics,
                                   $Element.ModificationCount, [System.Decimal]$Element.SamplingPercent, $Element.LastUpdate)
}  