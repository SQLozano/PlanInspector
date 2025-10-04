CREATE VIEW [{@Schema}].[vw_Duration]
AS
	SELECT 
		 qts.[CapturedPlan_id]
		,qts.[CpuTime]
		,qts.[ElapsedTime]
		,qts.[UdfCpuTime]
		,qts.[UdfElapsedTime]
		,ss.[QueryHash]
    ,cp.[database_name]
    ,TRY_CONVERT(XML,DECOMPRESS(CP.showplan_xml_compressed)) AS [showplan_xml]
		,cp.sql_text
	FROM 
		[{@Schema}].[QueryTimeStats] qts INNER JOIN
		[{@Schema}].[StmtSimple] ss ON ss.CapturedPlan_id = qts.CapturedPlan_id INNER JOIN
		[{@Schema}].[CapturedPlan] cp ON cp.CapturedPlan_id = ss.CapturedPlan_id