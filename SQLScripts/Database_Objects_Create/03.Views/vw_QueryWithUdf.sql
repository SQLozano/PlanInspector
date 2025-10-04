CREATE VIEW [{@Schema}].[vw_QueryWithUdf]
AS 
SELECT 
	 CP.[CapturedPlan_id]
	,TRY_CONVERT(XML,DECOMPRESS(CP.showplan_xml_compressed)) AS [showplan_xml]
	,[UdfCpuTime]
	,[UdfElapsedTime]
FROM 
	[{@Schema}].[QueryTimeStats] QTS
		INNER JOIN 
	[{@Schema}].[CapturedPlan] CP ON QTS.CapturedPlan_id = CP.CapturedPlan_id
WHERE 
	QTS.[UdfCpuTime] IS NOT NULL