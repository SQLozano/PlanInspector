PlanInspector

PlanInspector is a tool to analyze query plans that have been captured through Extended events.

To use PlanInspector, follow these steps:

Step 1  
  Capture query plans, you can use 'XE_query_post_execution_plan_profile.sql' in the SQL_Scripts folder as an example.  
  These plans will be written to .XEL files on your server.

Step 2  
  Adjust the 'Variables.xml' file.  
    'ServerName' the name of the server where we'll create the output database in 'Step3'  
    'XelFolder'  the folder with the XE files with the captured query plans  
                 e.g. :  
                        c:\temp\XEL  
                        \\SRV1\Share\XEL\  
    'DbName'     if you want to change the name of the output database (we'll call this database PLANUSAGEINFO)

Step 3  
  Start the script 'Invoke-Scripts.ps1', this will execute 3 other scripts:  
  'Build-Database.ps1' Creates the PLANUSAGEINFO database.  
  'Import-Xel.ps1'     Imports the XEL files into PLANUSAGEINFO.  
  'Write-Data.ps1'     Parses the XML of the query plans and writes the output to PLANUSAGEINFO.

Step 4  
  Analyze the output through the views on the PLANUSAGEINFO database.  
    vw_Actuals => compare Estimated to Actual rows  
    vw_Compile_TimeOut => queries who timed out during compilation  
    vw_Converted_Plans => converts query plans to xml format  
    vw_Duration => information about CPU en duration also for UDF  
    vw_Hashes => XE events doesn't store hashes in varbinary format, use this view to compare different hash formats  
    vw_Memory_PercentUsed => how much of the granted memory was used?  
    vw_MemoryGrantFeedbackAdjusted => queries with memory grant feedback  
    vw_Missing_Index => querie plans with missing index requests  
    vw_Multiple_Plans_Per_QueryHash => queries with multiple plans  
    vw_NonParallelPlanReason => why didn't this query run multi-threaded?  
    vw_Parallel_Skew => Compares load on the different threads of a parallel operator  
    vw_ParameterList => Shows the parameters that were used, compiled and runtime values  
    vw_PlanWarning_ColumnsWithNoStatistics => warnings about columns with no statistics  
    vw_PlanWarning_ColumnsWithStaleStatistics => warnings about stale statistics  
    vw_PlanWarning_ExchangeSpillDetails => warnings about Exchange spills  
    vw_PlanWarning_HashSpillDetails => warnings about Hash spills  
    vw_PlanWarning_MemoryGrantWarning => warnings about memory grants  
    vw_PlanWarning_NoJoinPredicate => warnings about joins without a predicate  
    vw_PlanWarning_Overview => overview of all the different warnings  
    vw_PlanWarning_PlanAffectingConvert => warnings about converts  
    vw_PlanWarning_SortSpillDetails => warnings about sort spills  
    vw_PlanWarning_SpillToTempDb => warnings about spills to tempdb  
    vw_PlanWarning_UnmatchedIndexes => warnings about Unmatched indexes  
    vw_PlanWarning_Wait => warnings about waits  
    vw_QueryWithUdf => queries with user defined functions  
    vw_Statistics_Not_Updated_Last_7_Days => statistics that are not updated in the last 7 days  
    vw_TraceFlags => queries who used traceflags

Contributing

We welcome contributions! Please see CONTRIBUTING.md for more information.
License

This project is licensed under the MIT License - see the LICENSE file for details.
