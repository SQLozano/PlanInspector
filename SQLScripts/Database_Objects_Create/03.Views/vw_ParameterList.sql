CREATE VIEW [{@Schema}].[vw_ParameterList]
AS
  SELECT  
    p.[CapturedPlan_id]
		,cp.[database_name]
    ,STRING_AGG(p.[Column] + ' ' + p.ParameterDataType  + ' ' + p.ParameterCompiledValue + ' ' + p.ParameterRuntimeValue,', ')WITHIN GROUP (order by [column]) AS [name_type_compiled_runtime]
    ,qts.[cputime]
    ,qts.[ElapsedTime]
    ,qts.[UdfCpuTime]
		,qts.[UdfElapsedTime]
    ,ss.[QueryHash]
    ,ss.[QueryPlanHash]
    ,TRY_CONVERT (XML,DECOMPRESS(CP.showplan_xml_compressed)) AS [showplan_xml]
		,cp.[sql_text]
  FROM 
    [{@Schema}].[ParameterList] p INNER JOIN 
    [{@Schema}].[QueryTimeStats] qts ON qts.CapturedPlan_id = p.CapturedPlan_id INNER JOIN 
    [{@Schema}].[StmtSimple] ss ON ss.CapturedPlan_id = p.CapturedPlan_id INNER JOIN 
    [{@Schema}].[CapturedPlan] cp ON p.CapturedPlan_id = cp.CapturedPlan_id 
  WHERE 
    p.ParameterCompiledValue IS NOT NULL
  GROUP BY 
     p.[CapturedPlan_id]
	,cp.[database_name]
    ,qts.[cputime]
    ,qts.[ElapsedTime]
    ,qts.[UdfCpuTime]
	,qts.[UdfElapsedTime]
    ,ss.[QueryHash]
    ,ss.[QueryPlanHash]
    ,cp.[showplan_xml_compressed]
	,cp.[sql_text];