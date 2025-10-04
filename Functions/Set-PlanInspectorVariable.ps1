Function Set-PlanInspectorVariable
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]$VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference'),
        [Parameter(Mandatory=$false)][string]$PlanInspector_Instance,
        [Parameter(Mandatory=$false)][string]$PlanInspector_Database,
        [Parameter(Mandatory=$false)][string]$PlanInspector_Schema,
        [Parameter(Mandatory=$false)][string]$PlanInspector_Table,
        [Parameter(Mandatory=$false)][string]$PlanInspector_Column
    )

    [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
    IF(!$user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)){
        Write-Host "This function must be run as Administrator in order to modify the system variables" -ForegroundColor Red
        RETURN
    }

    Write-Verbose -Message "PlanInspector environment variables set [START]"

    if($PlanInspector_Instance){
        Write-Verbose " Setting [`$Env:PlanInspector_Instance] (SYSTEM) = [$PlanInspector_Instance]"
        [Environment]::SetEnvironmentVariable("PlanInspector_Instance", $PlanInspector_Instance, "Machine")
        $env:PlanInspector_Instance=(
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","Machine"),
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","User")
        ) -match '.' -join ';'
        Write-Verbose "  [`$Env:PlanInspector_Instance] = [$PlanInspector_Instance]"
    }

    if($PlanInspector_Database){
        Write-Verbose "Setting [`$Env:PlanInspector_Database] (SYSTEM) = [$PlanInspector_Database]"
        [Environment]::SetEnvironmentVariable("PlanInspector_Database", $PlanInspector_Database, "Machine")
        $env:PlanInspector_Database=(
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Database","Machine"),
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Database","User")
        ) -match '.' -join ';'
        Write-Verbose "  [`$Env:PlanInspector_Database] = [$PlanInspector_Database]"
    }

    if($PlanInspector_Schema){
        Write-Verbose "Setting [`$Env:PlanInspector_Schema] (SYSTEM) = [$PlanInspector_Schema]"
        [Environment]::SetEnvironmentVariable("PlanInspector_Schema", $PlanInspector_Schema, "Machine")
        $env:PlanInspector_Schema=(
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","Machine"),
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","User")
        ) -match '.' -join ';'
        Write-Verbose "  [`$Env:PlanInspector_Schema] = [$PlanInspector_Schema]"
    }

    if($PlanInspector_Table){
        Write-Verbose "Setting [`$Env:PlanInspector_Table] (SYSTEM) = [$PlanInspector_Table]"
        [Environment]::SetEnvironmentVariable("PlanInspector_Table", $PlanInspector_Table, "Machine")
        $env:PlanInspector_Table=(
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Table","Machine"),
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Table","User")
        ) -match '.' -join ';'
        Write-Verbose "  [`$Env:PlanInspector_Table] = [$PlanInspector_Table]"
    }

    if($PlanInspector_Column){
        Write-Verbose "Setting [`$Env:PlanInspector_Column] (SYSTEM) = [$PlanInspector_Column]"
        [Environment]::SetEnvironmentVariable("PlanInspector_Column", $PlanInspector_Column, "Machine")
        $env:PlanInspector_Column=(
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Column","Machine"),
            [System.Environment]::GetEnvironmentVariable("PlanInspector_Column","User")
        ) -match '.' -join ';'
        Write-Verbose "  [`$Env:PlanInspector_Column] = [$PlanInspector_Column]"
    }

    Write-Verbose -Message "PlanInspector environment variables set [END]"
}