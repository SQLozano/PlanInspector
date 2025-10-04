#==================================================================================================
#Function: Write query plan information to $DtMissingIndex
#==================================================================================================
function Write-MissingIndex ([System.Data.DataTable]$DtMissingIndex,$XMLElement,$CapturedPlan_id)
{
  [void]$DtMissingIndex.Rows.Add
  (
      $CapturedPlan_id
  )

}  