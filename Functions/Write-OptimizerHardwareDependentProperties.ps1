#==================================================================================================
#Function: Write query plan information to $DtOptimizerHardwareDependentProperties
#==================================================================================================
function Write-OptimizerHardwareDependentProperties ([System.Data.DataTable]$DtOptimizerHardwareDependentProperties,$Element,$CapturedPlan_id)
{
  [void]$DtOptimizerHardwareDependentProperties.Rows.Add($null, $CapturedPlan_id,$Element.EstimatedAvailableMemoryGrant, $Element.EstimatedPagesCached,
                                                         $Element.EstimatedAvailableDegreeOfParallelism,$Element.MaxCompileMemory)
} 