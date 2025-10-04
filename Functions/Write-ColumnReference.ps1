#==================================================================================================
#Function: Writecolumn references to $DtColumnReference
#==================================================================================================
function Write-ColumnReference ([System.Data.DataTable]$DtColumnReference, $XMLElements,$CapturedPlan_id)
{
  foreach($XMLElement in $XMLElements)
  {
    if($XMLElement.Database){
      [void]$DtColumnReference.Rows.Add($null
      ,$CapturedPlan_id
      ,(($XMLElement.Database).Replace("[","")).Replace("]","")
      ,(($XMLElement.Schema).Replace("[","")).Replace("]","")
      ,(($XMLElement.Table).Replace("[","")).Replace("]","")
      ,(($XMLElement.Column).Replace("[","")).Replace("]","")
      )
    }
  }
}  