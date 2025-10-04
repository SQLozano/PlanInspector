function Get-LastQDSPlan{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]$VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference'),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Instance = [System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Database = [System.Environment]::GetEnvironmentVariable("PlanInspector_Database","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Schema   = [System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Table    = [System.Environment]::GetEnvironmentVariable("PlanInspector_Table","Machine"),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Column   = [System.Environment]::GetEnvironmentVariable("PlanInspector_Column","Machine"),
        [Parameter(Mandatory=$false)][string]$source,
        [Parameter(Mandatory=$false)][string]$database_name,
        [Parameter(Mandatory=$false)][string]$object_name,
        [Parameter(Mandatory=$false)][int64]$query_id
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

if(!($source) -And !($database_name) -And !($object_name) -And !($query_id)){
    $GetPlanQuery = "SELECT
     [source]
    ,[database_name]
    ,NULL AS [object_name]
    ,NULL AS [query_id]
    ,MAX(plan_id) AS [plan_id]
    FROM [{@PlanInspector_Schema}].[{@PlanInspector_Table}]
    GROUP BY
     [source]
    ,[database_name]"
} else {

    $GetPlanQuery = "SELECT
     [source]
    ,[database_name]
    ,{@SELECT_object_name}
    ,{@SELECT_query_id}
    ,MAX(plan_id) AS [plan_id]
    FROM [{@PlanInspector_Schema}].[{@PlanInspector_Table}]
    WHERE 1 = 1
    --{@WHERE_source}
    --{@WHERE_database_name}
    --{@WHERE_object_name}
    --{@WHERE_query_id}
    GROUP BY 
     [source]
    ,[database_name]
    --{@GROUPBY_object_name}
    --{@GROUPBY_query_id}
    "

    if($source){
        $GetPlanQuery = $GetPlanQuery.Replace("--{@WHERE_source}","AND [source] = '$($source)'")
    }
    if($database_name){
        $GetPlanQuery = $GetPlanQuery.Replace("--{@WHERE_database_name}","AND [database_name] = '$($database_name)'")
    }

    if($object_name){
        $GetPlanQuery = $GetPlanQuery.Replace("{@SELECT_object_name}","'$($object_name)' AS [object_name]")
        $GetPlanQuery = $GetPlanQuery.Replace("--{@WHERE_object_name}","AND [object_name] = '$($object_name)'")
        $GetPlanQuery = $GetPlanQuery.Replace("--{@GROUPBY_object_name}",",[object_name]")
    } else {
        $GetPlanQuery = $GetPlanQuery.Replace("{@SELECT_object_name}","NULL AS [object_name]")
    }


    if($query_id){
        $GetPlanQuery = $GetPlanQuery.Replace("{@SELECT_query_id}","$($query_id) AS [query_id]")
        $GetPlanQuery = $GetPlanQuery.Replace("--{@WHERE_query_id}","AND [query_id] = $($query_id)")
        $GetPlanQuery = $GetPlanQuery.Replace("--{@GROUPBY_query_id}",",[query_id]")
    } else {
        $GetPlanQuery = $GetPlanQuery.Replace("{@SELECT_query_id}","NULL AS [query_id]")
    }
}

$GetPlanQuery = $GetPlanQuery.Replace('{@PlanInspector_Schema}',$PlanInspector_Schema)
$GetPlanQuery = $GetPlanQuery.Replace('{@PlanInspector_Table}',"$($PlanInspector_Table)")

Write-Verbose "Query to get the last execution plans:"
Write-Verbose $GetPlanQuery

# $InstanceConnection = New-Object System.Data.SqlClient.SqlConnection
# $InstanceConnection.ConnectionString = "server='$PlanInspector_Instance';database='$PlanInspector_Database';Integrated Security = True;"
#     $InstanceConnection.Open()
#     $InstanceCommand = New-Object System.Data.SqlClient.SqlCommand
#     $InstanceCommand.Connection = $InstanceConnection
#     $InstanceCommand.CommandText = $GetPlanQuery
#     $InstanceCommand.CommandTimeout = 6000
#     $InstanceReader = $InstanceCommand.ExecuteReader()
#     $QueryResults = New-Object System.Data.DataTable
#     $QueryResults.Load($InstanceReader)
# $QueryResults
}