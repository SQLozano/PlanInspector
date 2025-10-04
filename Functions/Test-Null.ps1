#==================================================================================================
#Function: Check for a null value and adjust
#==================================================================================================
Function Test-Null ($Value)
{
  try
  {
    Switch ($Value)
    {
      $null   {break}
      default {$Value = $Value.Replace('[','').Replace(']','');break}
    }
  }
  catch
  {
    throw
  }
  Return $Value
}