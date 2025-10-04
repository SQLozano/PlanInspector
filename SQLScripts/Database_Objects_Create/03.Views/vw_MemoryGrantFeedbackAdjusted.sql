CREATE VIEW [{@Schema}].[vw_MemoryGrantFeedbackAdjusted]
AS 
SELECT 
	 CP.[CapturedPlan_id]
	,TRY_CONVERT(XML,DECOMPRESS(CP.showplan_xml_compressed)) AS [showplan_xml]
	,[IsMemoryGrantFeedbackAdjusted]
FROM 
	[{@Schema}].[MemoryGrantInfo] MG
		INNER JOIN 
	[{@Schema}].[CapturedPlan] CP ON MG.CapturedPlan_id = CP.CapturedPlan_id
WHERE 
	MG.[IsMemoryGrantFeedbackAdjusted] IS NOT NULL
	AND 
	MG.[IsMemoryGrantFeedbackAdjusted] IN ('Yes: Adjusting','Yes: Stable','Yes: Percentile Adjusting');