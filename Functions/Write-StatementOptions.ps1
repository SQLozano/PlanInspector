#==================================================================================================
#Function: Write query plan information to $DtStatementSetOptions
#==================================================================================================
function Write-StatementSetOptions ([System.Data.DataTable]$DtStatementSetOptions, $Elements, $CapturedPlan_id)
{
  [void]$DtStatementSetOptions.Rows.Add(
       $null
      ,$CapturedPlan_id
      ,$Element.ANSI_NULLS
      ,$Element.ANSI_PADDING
      ,$Element.ANSI_WARNINGS
      ,$Element.ARITHABORT
      ,$Element.CONCAT_NULL_YIELDS_NULL
      ,$Element.NUMERIC_ROUNDABORT
      ,$Element.QUOTED_IDENTIFIER
  )
}