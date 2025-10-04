CREATE VIEW [{@Schema}].[vw_ParameterListRuntime]
AS
  SELECT  
    p.CapturedPlan_id 
    ,cp.timestamp
    ,STRING_AGG(p.[Column] + ' ' + p.ParameterDataType  + ' ' + p.ParameterRuntimeValue,', ')WITHIN GROUP (order by [column]) AS [parameter_info]
    ,qts.cputime
    ,qts.ElapsedTime
    ,ss.QueryHash
    ,ss.QueryPlanHash
    ,TRY_CONVERT (XML,DECOMPRESS(CP.showplan_xml_compressed)) AS [showplan_xml]
  FROM 
    [{@Schema}].[ParameterList] p INNER JOIN 
    [{@Schema}].[QueryTimeStats] qts ON qts.CapturedPlan_id = p.CapturedPlan_id INNER JOIN 
    [{@Schema}].[StmtSimple] ss ON ss.CapturedPlan_id = p.CapturedPlan_id INNER JOIN 
    [{@Schema}].[CapturedPlan] cp ON p.CapturedPlan_id = cp.CapturedPlan_id 
  WHERE 
    p.ParameterCompiledValue IS NOT NULL
  GROUP BY 
    p.CapturedPlan_id
    ,qts.cputime
    ,qts.ElapsedTime
    ,ss.QueryHash
    ,ss.QueryPlanHash
    ,cp.[showplan_xml_compressed]
    ,cp.timestamp