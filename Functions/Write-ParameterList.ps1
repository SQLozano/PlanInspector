#==================================================================================================
#Function: Write parameter information to $DtParameterList
#==================================================================================================
function Write-ParameterList ([System.Data.DataTable]$DtParameterList,$XMLElements, $CapturedPlan_id)
{
  foreach ($XMLElement in $XMLElements)
  {
    [void]$DtParameterList.Rows.Add($null
      ,$CapturedPlan_id
      ,$XMLElement.Column
      ,$XMLElement.ParameterDataType
      ,$XMLElement.ParameterCompiledValue
      ,$XMLElement.ParameterRuntimeValue
    )
  }
}  