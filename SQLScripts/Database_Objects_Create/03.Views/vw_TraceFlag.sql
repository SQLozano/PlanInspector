CREATE VIEW [{@Schema}].[vw_TraceFlag]
AS
SELECT     
	[{@Schema}].[CapturedPlan].[database_name], 
	[{@Schema}].[TraceFlag].[Value], 
	[{@Schema}].[TraceFlag].[Scope], 
	TRY_CONVERT(xml,[{@Schema}].[CapturedPlan].[showplan_xml]) AS [showplan_xml], 
	[{@Schema}].[CapturedPlan].[sql_text]
FROM        
	[{@Schema}].[CapturedPlan] 
	INNER JOIN                
	[{@Schema}].[TraceFlag] ON [{@Schema}].[CapturedPlan].[CapturedPlan_id] = [{@Schema}].[TraceFlag].[CapturedPlan_id]