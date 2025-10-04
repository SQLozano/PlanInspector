Function Import-CachePlan
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]$VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference'),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Instance = [System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Database = [System.Environment]::GetEnvironmentVariable("PlanInspector_Database","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Schema   = [System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Table    = [System.Environment]::GetEnvironmentVariable("PlanInspector_Table","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Column   = [System.Environment]::GetEnvironmentVariable("PlanInspector_Column","Machine"),
        [Parameter(Mandatory=$true)][Byte[]]$Plan_Handle,
        [Parameter(Mandatory=$true)][string]$Target_Instance,
        [Parameter(Mandatory=$false)][string]$Notes
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
IF(!$Target_Instance){
    Write-Output "No value for Target_Instance was provided" -ForegroundColor Yellow
    Write-Output "Use the parameter -Target_Instance when execution this function" -ForegroundColor Yellow
    $MissingVariable = 1
}
IF(!$Target_Database){
    Write-Output "No value for Target_Database was provided" -ForegroundColor Yellow
    Write-Output "Use the parameter -Target_Database when execution this function" -ForegroundColor Yellow
    $MissingVariable = 1
}
IF(!$Target_PlanID){
    Write-Output "No value for Target_PlanID was provided" -ForegroundColor Yellow
    Write-Output "Use the parameter -Target_PlanID when execution this function" -ForegroundColor Yellow
    $MissingVariable = 1
}

IF($MissingVariable){
    Write-Output "Required parameters were missing" -ForegroundColor Red
    Write-Output "Check error messages above to fix the issue" -ForegroundColor Red
}

$QueryQDSData = "SELECT
 [CapturedPlan_id]          =   NULL
,[name]						=	NULL
,[timestamp]                =   GETDATE()
,[timestamp (UTC)]          =   GETUTCDATE()
,[source_database_id]		=	DB_ID()
,[object_type]				=	COALESCE(o.type_desc, 'ADHOC')
,[object_id]				=	qsq.object_id
,[nest_level]				=	NULL
,[cpu_time]					=	NULL
,[duration]					=	NULL
,[estimated_rows]			=	NULL
,[estimated_cost]			=	NULL
,[serial_ideal_memory_kb]	=	NULL
,[requested_memory_kb]		=	NULL
,[used_memory_kb]			=	NULL
,[ideal_memory_kb]			=	NULL
,[granted_memory_kb]		=	NULL
,[dop]						=	NULL
,[object_name]				=	COALESCE(s.name + '.' + o.name, 'ADHOC')
,[showplan_xml]				=	qsp.query_plan
,[showplan_xml_compressed]	=	NULL
,[database_name]			=	DB_NAME()
,[transaction_id]			=	NULL
,[sql_text]					=	qsqt.query_sql_text
,[sql_text_compressed]		=	NULL
,[query_plan_hash]			=	NULL
,[query_hash]				=	qsq.query_hash
,[nt_username]				=	NULL
,[client_hostname]			=	NULL
,[task_time]				=	NULL
,[begin_offset]				=	NULL
,[end_offset]				=	NULL
,[plan_handle]				=	qsp.query_plan_hash
,[sql_handle]				=	qsqt.statement_sql_handle
,[recompile_count]			=	NULL
,[sourcetype]				=	'QueryStore'
,[source]					=	@@SERVERNAME
,[query_id]					=	qsp.query_id
,[plan_id]					=	qsp.plan_id
FROM sys.query_store_plan qsp
INNER JOIN sys.query_store_query qsq
ON qsp.query_id = qsq.query_id
INNER JOIN sys.query_store_query_text qsqt
ON qsq.query_text_id = qsqt.query_text_id
LEFT JOIN sys.objects o
ON qsq.object_id = o.object_id
LEFT JOIN sys.schemas s
ON o.schema_id = s.schema_id
WHERE qsp.plan_id = {@Target_PlanID}"
$QueryQDSData = ($QueryQDSData.Replace("{@Target_PlanID}","$($Target_PlanID)"))
Write-Verbose $QueryQDSData

Write-Verbose "Connecting to [$Target_Instance] \ [$Target_Database] to extract the @Target_PlanID = $($Target_PlanID)"
$InstanceConnection = New-Object System.Data.SqlClient.SqlConnection
$InstanceConnection.ConnectionString = "server='$Target_Instance';database='$Target_Database';Integrated Security = True;"
$InstanceConnection.Open()
$InstanceCommand = New-Object System.Data.SqlClient.SqlCommand
$InstanceCommand.Connection = $InstanceConnection
$InstanceCommand.CommandText = $QueryQDSData
$InstanceCommand.CommandTimeout = 6000
$InstanceReader = $InstanceCommand.ExecuteReader()
$QueryResults = New-Object System.Data.DataTable
$QueryResults.Load($InstanceReader)

$NotesColumn = [System.Data.DataColumn]::new('Notes', [string])
$NotesColumn.DefaultValue = $Notes
$QueryResults.Columns.Add($NotesColumn)


Write-Verbose "[$(Get-Date)] Start QDS data load into [$($PlanInspector_Instance)]\[$($PlanInspector_Database)].[$($PlanInspector_Schema)].[$($PlanInspector_Table)]"
Write-SqlTableData -ServerInstance $PlanInspector_Instance -Database $PlanInspector_Database -SchemaName $PlanInspector_Schema -TableName $PlanInspector_Table -InputData $QueryResults
Write-Verbose "[$(Get-Date)] End QDS data load into [$($PlanInspector_Instance)]\[$($PlanInspector_Database)].[$($PlanInspector_Schema)].[$($PlanInspector_Table)]"
}