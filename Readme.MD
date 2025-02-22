PlanInspector

PlanInspector is a tool to analyze query plans that have been captured trough Extended events. 

To use PlanInspector, follow these steps:

Step 1    
  Capture query plans, you can use 'XE_query_post_execution_plan_profile.sql'  in the SQL_Scripts folder as an example. 
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
  


Contributing

We welcome contributions! Please see CONTRIBUTING.md for more information.
License

This project is licensed under the MIT License - see the LICENSE file for details.
