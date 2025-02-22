#Param([Parameter(Mandatory=$false)] [string]$DbName = 'test')
#==================================================================================================
#Function: Write query plan info to the database
#==================================================================================================
Function Write-DataTableToDatabase
{
  [CmdletBinding()]
  [OutputType([system.Data.DataTable])]
  Param
  (
    #Database where the output is written
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
    [string]$DbName,

    #Server where the output is written
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
    [string]$ServerName,

    #Table where the output is written
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
    [string]$TableOutput,

    #Datatable that is written to the database
    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
    [data.datatable]$DataTable
  )
  Try
  {
    $cn = new-object System.Data.SqlClient.SqlConnection("Data Source=$ServerName;Integrated Security=SSPI;Initial Catalog=$DbName")
    $cn.Open()
    $bc = new-object ("System.Data.SqlClient.SqlBulkCopy") $cn
    $bc.BulkCopyTimeout = 600;
    $bc.BatchSize = 1000
    $bc.DestinationTableName = "$TableOutput"
    $bc.WriteToServer($DataTable)
    $cn.Close()
  }
  Catch
  {
    $Error[0] | Format-List -force
    Throw
  }
}

$StartTime = Get-Date
Write-Output $StartTime
#==================================================================================================
#Read variables from xml file
#==================================================================================================
try
{
  $XmlLocation    = ".\PowerShellScripts\Variables.xml"
  [xml]$Variables = Get-Content $XmlLocation -ErrorAction Stop
  $ServerName     = $Variables.General.ServerName
  $DbName         = $Variables.General.DbName
  $XelFolder      = $Variables.General.XelFolder
  $XeEvents       = $Variables.GetElementsByTagName('XeEvent') 
  $TableOutput    = $Variables.General.TableName
}
catch
{
  $Error[0] | Format-List -force
  Throw
}
#==================================================================================================
#Retrieve all xel files in the folder.
#==================================================================================================
try 
{
  $XelFiles = Get-ChildItem $XelFolder*.xel  
}
catch 
{
  Throw
}
#==================================================================================================
#Add the supported events to the arraylist $SupportedEvents.
#==================================================================================================
$SupportedEvents = New-Object System.Collections.ArrayList 
foreach ($XeEvent in $XeEvents)
{
  [void]$SupportedEvents.Add($XeEvent.Name)
}
#==================================================================================================
#Create datatable $DataXel.
#Write-Log -FileName $OutFile -Message 'Create datatable $DataXel'
#==================================================================================================
$DtXel = New-Object System.Data.DataTable 
[void]$DtXel.Columns.Add("name"                  ,"String")
[void]$DtXel.Columns.Add("timestamp"             ,"DateTimeOffset")
[void]$DtXel.Columns.Add("timestamp (UTC)"       ,"DateTimeOffset")
[void]$DtXel.Columns.Add("source_database_id"    ,"int32")
[void]$DtXel.Columns.Add("object_type"           ,"String")
[void]$DtXel.Columns.Add("object_id"             ,"int32")
[void]$DtXel.Columns.Add("nest_level"            ,"int32")
[void]$DtXel.Columns.Add("cpu_time"              ,"double")
[void]$DtXel.Columns.Add("duration"              ,"double")
[void]$DtXel.Columns.Add("estimated_rows"        ,"int32")
[void]$DtXel.Columns.Add("estimated_cost"        ,"int32")
[void]$DtXel.Columns.Add("serial_ideal_memory_kb","double")
[void]$DtXel.Columns.Add("requested_memory_kb"   ,"double")
[void]$DtXel.Columns.Add("used_memory_kb"        ,"double")
[void]$DtXel.Columns.Add("ideal_memory_kb"       ,"double")
[void]$DtXel.Columns.Add("granted_memory_kb"     ,"double")
[void]$DtXel.Columns.Add("dop"                   ,"int32")
[void]$DtXel.Columns.Add("object_name"           ,"String")
[void]$DtXel.Columns.Add("showplan_xml"          ,"String")
[void]$DtXel.Columns.Add("database_name"         ,"String")
[void]$DtXel.Columns.Add("transaction_id"        ,"int64")
[void]$DtXel.Columns.Add("sql_text"              ,"String")
[void]$DtXel.Columns.Add("query_plan_hash"       ,"UInt64")
[void]$DtXel.Columns.Add("query_hash"            ,"UInt64")
[void]$DtXel.Columns.Add("nt_username"           ,"string")
[void]$DtXel.Columns.Add("client_hostname"       ,"string")
[void]$DtXel.Columns.Add("task_time"             ,"double")
[void]$DtXel.Columns.Add("begin_offset"          ,"UInt64")
[void]$DtXel.Columns.Add("end_offset"            ,"UInt64")
[void]$DtXel.Columns.Add("plan_handle"           ,"Byte[]")
[void]$DtXel.Columns.Add("sql_handle"            ,"Byte[]")
[void]$DtXel.Columns.Add("recompile_count"       ,"double")
#==================================================================================================
#Read XelFile
#==================================================================================================
Foreach ($XelFile in $XelFiles)
{
  try 
  {
    #Read a line from the XEL file
    $DataXel = Read-SqlXEvent $XelFile -ErrorAction Stop
    $DataXel = $DataXel | Where-Object {$SupportedEvents -contains $PsItem.name} #Remove unsupported events
    foreach ($Row in $DataXel)
    {
      #Create a new row in the datatable
      $arrayrow = $DtXel.NewRow()
      $arrayrow["name"]            = $Row.name
      $arrayrow["TimeStamp"]       = $Row.TimeStamp
      $arrayrow["timestamp (UTC)"] = $Row.TimeStamp.ToUniversalTime()
      #add a value to the corresponding column in the new datarow 
      #field keys are retrieved from the 'Event Fields' Pain in the XE GUI
      foreach ($field in $Row.Fields) 
      {
        $arrayrow[$field.Key] = $field.Value     
      }
      #dictionary keys are retrieved from the 'Global Fields' Pain in the XE GUI
      $dictionary = $Row.Actions
      foreach ($key in $dictionary.Keys) 
      { 
        $arrayrow[$key] = $dictionary[$key]
      } 
      [void]$DtXel.rows.Add($arrayrow)
    }
  }
  catch
  {
    throw
  }
}
#==================================================================================================
#Write extended events to the database
#==================================================================================================
$BulkCopyStart = Get-Date
Write-Output "Start bulkcopy $BulkCopyStart"
Write-DataTableToDatabase -DbName $DbName -ServerName $ServerName -TableOutput $TableOutput -DataTable $DtXel
#==================================================================================================
#End of general script
#==================================================================================================
$EndTime = Get-Date
New-TimeSpan -Start $StartTime -End $EndTime | Select-Object -Property totalminutes, totalSeconds | Format-List
Write-Output "End of script."
