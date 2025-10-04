CREATE VIEW [{@Schema}].[vw_NonParallelPlanReason]
AS
SELECT 
   CP.[CapturedPlan_id]
	,QP.[NonParallelPlanReason] 
	,TRY_CONVERT(XML,DECOMPRESS(CP.showplan_xml_compressed)) AS [showplan_xml]
FROM 
	[{@Schema}].[QueryPlan] QP
		INNER JOIN 
	[{@Schema}].[CapturedPlan] CP ON QP.CapturedPlan_id = CP.CapturedPlan_id
WHERE
	QP.[NonParallelPlanReason] IS NOT NULL;