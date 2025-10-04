CREATE VIEW [{@Schema}].[vw_Memory_PercentUsed]
AS 
SELECT 
	 CP.[CapturedPlan_id]
	,TRY_CONVERT(XML,DECOMPRESS(CP.showplan_xml_compressed)) AS [showplan_xml]
	,MG.[GrantedMemory]
	,MG.[MaxUsedMemory]
	,CAST((100.0 /MG.[GrantedMemory] * MG.[MaxUsedMemory]) AS DECIMAL(18,2)) as PercentageUsed
FROM 
	[{@Schema}].[MemoryGrantInfo] MG
		INNER JOIN 
	[{@Schema}].[CapturedPlan] CP ON MG.CapturedPlan_id = CP.CapturedPlan_id
WHERE 
	MG.[GrantedMemory] > 0;