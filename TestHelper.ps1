# This file is a help for testing changes in the module, not part of the module itself
# It includes calls to the main functions to test it after changes have been made locally
$CurrentLocation = Get-Location
Import-Module $CurrentLocation -Verbose -Force
Remove-PlanInspectorDatabase -Verbose
Add-PlanInspectorDatabase -Verbose
Add-PlanInspectorDatabaseObjects -Verbose
Remove-PlanInspectorDatabaseObjects -Verbose
Add-PlanInspectorDatabaseObjects -Verbose
Import-XELPlan -XelFile "C:\wherever_you_have_the_extended_event_file.xel" -Verbose
Import-QDSPlan -Target_Instance "server_to_get_QDS_data_from" -Target_Database "database_to_get_QDS_data_from" -Target_Object "object_to_get_QDS_data_from" -Notes "Some QDS plans" -Verbose

$CapturedPlan_id = 1
$Plan = Export-ExecutionPlan -CapturedPlan_id $CapturedPlan_id -Verbose
if($Plan) {
    Submit-ExecutionPlanAnalysis -ExecutionPlans $Plan -Verbose
}

