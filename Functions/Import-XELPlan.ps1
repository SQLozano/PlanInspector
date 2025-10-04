Function Import-XELPlan
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]$VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference'),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Instance = [System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Database = [System.Environment]::GetEnvironmentVariable("PlanInspector_Database","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Schema   = [System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Table    = [System.Environment]::GetEnvironmentVariable("PlanInspector_Table","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Column   = [System.Environment]::GetEnvironmentVariable("PlanInspector_Column","Machine"),
        [Parameter(Mandatory=$false)][string]$Notes,
        [Parameter(Mandatory=$true)][string]$XelFile
)
Import-Module SqlServer
# For versions >= 22 of the SqlServer PS module, the default encryption changed so it must be manually set Encrypt
if( (Get-Module -Name "sqlserver").Version.Major -ge 22){
    Write-Verbose "Version of the SQLServer module >= 22, so using '-Encrypt Optional' for SQL connections"
    $EncryptionParameter = @{Encrypt = "Optional"}
}
IF(!$PlanInspector_Instance){
    Write-Output "No value for PlanInspector_Instance was provided" -ForegroundColor Yellow
    Write-Output "Either use the parameter -PlanInspector_Instance when execution this function," -ForegroundColor Yellow
    Write-Output "or set the environment variable with the function 'Set-PlanInspectorVariable -PlanInspector_Database xxxxxxxx'" -ForegroundColor Yellow
    $MissingVariable = 1
}
IF(!$PlanInspector_Database){
    Write-Output "No value for PlanInspector_Database was provided" -ForegroundColor Yellow
    Write-Output "Either use the parameter -PlanInspector_Database when execution this function," -ForegroundColor Yellow
    Write-Output "or set the environment variable with the function 'Set-PlanInspectorVariable -PlanInspector_Database xxxxxxxx'" -ForegroundColor Yellow
    $MissingVariable = 1
}
IF(!$PlanInspector_Schema){
    Write-Output "No value for PlanInspector_Schema was provided" -ForegroundColor Yellow
    Write-Output "Either use the parameter -PlanInspector_Schema when execution this function," -ForegroundColor Yellow
    Write-Output "or set the environment variable with the function 'Set-PlanInspectorVariable -PlanInspector_Schema xxxxxxxx'" -ForegroundColor Yellow
    $MissingVariable = 1
}
IF(!$PlanInspector_Table){
    Write-Output "No value for PlanInspector_Table was provided" -ForegroundColor Yellow
    Write-Output "Either use the parameter -PlanInspector_Table when execution this function," -ForegroundColor Yellow
    Write-Output "or set the environment variable with the function 'Set-PlanInspectorVariable -PlanInspector_Table xxxxxxxx'" -ForegroundColor Yellow
    $MissingVariable = 1
}
IF(!$PlanInspector_Column){
    Write-Output "No value for PlanInspector_Column was provided" -ForegroundColor Yellow
    Write-Output "Either use the parameter -PlanInspector_Column when execution this function," -ForegroundColor Yellow
    Write-Output "or set the environment variable with the function 'Set-PlanInspectorVariable -PlanInspector_Column xxxxxxxx'" -ForegroundColor Yellow
    $MissingVariable = 1
}
IF($MissingVariable){
    Write-Output "Required parameters were missing" -ForegroundColor Red
    Write-Output "Check error messages above to fix the issue" -ForegroundColor Red
}

Write-Verbose "Verifying the XELfile containing execution plans"
IF(!(Test-Path $XelFile)){
    Write-Host "The file $($XelFile) does not exist. Make sure the file exists and the full path name is used" -ForegroundColor Red
    RETURN
}


$DtXel = New-Object System.Data.DataTable 
[void]$DtXel.Columns.Add("CapturedPlan_id"       ,"int32")
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
[void]$DtXel.Columns.Add("showplan_xml_compressed" ,"Byte[]")
[void]$DtXel.Columns.Add("database_name"         ,"String")
[void]$DtXel.Columns.Add("transaction_id"        ,"int64")
[void]$DtXel.Columns.Add("sql_text"              ,"String")
[void]$DtXel.Columns.Add("sql_text_compressed"   ,"Byte[]")
[void]$DtXel.Columns.Add("query_plan_hash"       ,"Byte[]")
[void]$DtXel.Columns.Add("query_hash"            ,"Byte[]")
[void]$DtXel.Columns.Add("nt_username"           ,"string")
[void]$DtXel.Columns.Add("client_hostname"       ,"string")
[void]$DtXel.Columns.Add("task_time"             ,"double")
[void]$DtXel.Columns.Add("begin_offset"          ,"UInt64")
[void]$DtXel.Columns.Add("end_offset"            ,"UInt64")
[void]$DtXel.Columns.Add("plan_handle"           ,"Byte[]")
[void]$DtXel.Columns.Add("sql_handle"            ,"Byte[]")
[void]$DtXel.Columns.Add("recompile_count"       ,"double")
[void]$DtXel.Columns.Add("sourcetype"            ,"String")
[void]$DtXel.Columns.Add("source"                ,"String")
[void]$DtXel.Columns.Add("query_id"              ,"int64")
[void]$DtXel.Columns.Add("plan_id"               ,"int64")
[void]$DtXel.Columns.Add("notes"                 ,"String")
[void]$DtXel.Columns.Add("processed"             ,"boolean")


Write-Verbose "Loading the XELfile contents into the $DTXel DataTable"
#Read a line from the XEL file
$DataXel = Read-SqlXEvent $XelFile -ErrorAction Stop
$SupportedEvents = @("query_post_compilation_showplan","query_post_execution_plan_profile","query_post_execution_showplan")
$DataXel = $DataXel | Where-Object {$SupportedEvents -contains $PsItem.name} #Remove unsupported events
foreach ($Row in $DataXel)
{
  #Create a new row in the datatable
  $arrayrow = $DtXel.NewRow()
  $arrayrow["name"]            = $Row.name
  $arrayrow["TimeStamp"]       = $Row.TimeStamp
  $arrayrow["timestamp (UTC)"] = $Row.TimeStamp.ToUniversalTime()
  $arrayrow["sourcetype"]      = "XEL"
  $arrayrow["source"]          = $XelFile
  $arrayrow["notes"]           = $Notes
  $arrayrow["processed"]       = $false
  # add a value to the corresponding column in the new datarow 
  # field keys are retrieved from the 'Event Fields' Pain in the XE GUI
  foreach ($field in $Row.Fields) 
  {
    # IF(($key -eq "showplan_xml") -or ($key -eq "sql_text")){
    #     CONTINUE
    # }
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

Write-Verbose "[$(Get-Date)] Start bulkcopy from [$($XelFile)] into [$($PlanInspector_Instance)]\[$($PlanInspector_Database)].[$($PlanInspector_Schema)].[$($PlanInspector_Table)]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName $PlanInspector_Table -InputData $DtXel -Timeout 300
Write-Verbose "[$(Get-Date)] End bulkcopy from [$($XelFile)] into [$($PlanInspector_Instance)]\[$($PlanInspector_Database)].[$($PlanInspector_Schema)].[$($PlanInspector_Table)]"
}
