#==================================================================================================
#Function: Write query plan information to $DtMemoryGrantInfo
#==================================================================================================
function Write-MemoryGrantInfo ([System.Data.DataTable]$DtMemoryGrantInfo, $XMLElement,$CapturedPlan_id)
{
  [void]$DtMemoryGrantInfo.Rows.Add($null,$CapturedPlan_id    ,$XMLElement.SerialRequiredMemory    ,$XMLElement.SerialDesiredMemory    ,$XMLElement.RequiredMemory    ,$XMLElement.DesiredMemory    ,$XMLElement.RequestedMemory    ,$XMLElement.GrantWaitTime    ,$XMLElement.GrantedMemory    ,$XMLElement.MaxUsedMemory    ,$XMLElement.MaxQueryMemory    ,$XMLElement.LastRequestedMemory    ,$XMLElement.IsMemoryGrantFeedbackAdjusted  )
}  