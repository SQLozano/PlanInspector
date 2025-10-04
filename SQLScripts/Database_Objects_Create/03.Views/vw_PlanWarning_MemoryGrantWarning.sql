CREATE VIEW [{@Schema}].[vw_PlanWarning_MemoryGrantWarning]
AS
	SELECT 
		 w.[Warning_id]
		,w.[CapturedPlan_id]
		,[IsMemoryGrantWarning]
		,[GrantWarningType]
		,[RequestedMemory]
		,[GrantedMemory]
		,[MaxUsedMemory]
		,TRY_CONVERT(XML,DECOMPRESS(CP.showplan_xml_compressed)) AS [showplan_xml]
		,cp.sql_text
	FROM  
		[{@Schema}].[Warning]  w
			INNER JOIN 
		[{@Schema}].[CapturedPlan] cp ON w.CapturedPlan_id = cp.CapturedPlan_id
	WHERE 
		IsMemoryGrantWarning = 1