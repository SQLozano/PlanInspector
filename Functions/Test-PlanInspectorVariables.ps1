Function Test-PlanInspectorVariables
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]$VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    )
    Write-Verbose -Message "PlanInspector environment variables check [START]"
    if(![System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","Machine")){
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Instance`",`"Machine`") not set" -ForegroundColor Red
        Write-Host "  To fix it, run Set-PlanInspectorVariable -PlanInspector_Instance 'xxxxxxxxx'"
    } else {
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Instance`",`"Machine`") = $([System.Environment]::GetEnvironmentVariable("PlanInspector_Instance","Machine"))" -Foreground Green
        Write-Host "  To change it, run Set-PlanInspectorVariable -PlanInspector_Instance 'xxxxxxxxx'"
    }

    if(![System.Environment]::GetEnvironmentVariable("PlanInspector_Database","Machine")){
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Database`",`"Machine`") not set" -ForegroundColor Red
        Write-Host " To fix it, run Set-PlanInspectorVariable -PlanInspector_Database 'xxxxxxxxx'"
    } else {
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Database`",`"Machine`") = $([System.Environment]::GetEnvironmentVariable("PlanInspector_Database","Machine"))" -Foreground Green
        Write-Host "  To change it, run Set-PlanInspectorVariable -PlanInspector_Database 'xxxxxxxxx'"
    }

    if(![System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","Machine")){
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Schema`",`"Machine`") not set" -ForegroundColor Red
        Write-Host "  To fix it, run Set-PlanInspectorVariable -PlanInspector_Schema 'xxxxxxxxx'"
    } else {
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Schema`",`"Machine`") = $([System.Environment]::GetEnvironmentVariable("PlanInspector_Schema","Machine"))" -Foreground Green
        Write-Host "  To change it, run Set-PlanInspectorVariable -PlanInspector_Schema 'xxxxxxxxx'"
    }

    if(![System.Environment]::GetEnvironmentVariable("PlanInspector_Table","Machine")){
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Table`",`"Machine`") not set" -ForegroundColor Red
        Write-Host "  To fix it, run Set-PlanInspectorVariable -PlanInspector_Table 'xxxxxxxxx'"
    } else {
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Table`",`"Machine`") = $([System.Environment]::GetEnvironmentVariable("PlanInspector_Table","Machine"))" -Foreground Green
        Write-Host "  To change it, run Set-PlanInspectorVariable -PlanInspector_Table 'xxxxxxxxx'"
    }

    if(![System.Environment]::GetEnvironmentVariable("PlanInspector_Column","Machine")){
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Column`",`"Machine`") not set" -ForegroundColor Red
        Write-Host "  To fix it, run Set-PlanInspectorVariable -PlanInspector_Column 'xxxxxxxxx'"
    } else {
        Write-Host " [System.Environment]::GetEnvironmentVariable(`"PlanInspector_Column`",`"Machine`") = $([System.Environment]::GetEnvironmentVariable("PlanInspector_Column","Machine"))" -Foreground Green
        Write-Host "  To change it, run Set-PlanInspectorVariable -PlanInspector_Column 'xxxxxxxxx'"
    }
    Write-Verbose "PlanInspector environment variables check [END]"
}