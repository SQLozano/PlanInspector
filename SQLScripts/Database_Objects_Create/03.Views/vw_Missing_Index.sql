CREATE VIEW [{@Schema}].[vw_Missing_Index]
AS
	SELECT  
		 CP.[CapturedPlan_id]
		,TRY_CONVERT(XML,DECOMPRESS(CP.showplan_xml_compressed)) AS [showplan_xml]
	FROM
		[{@Schema}].[MissingIndex] MI
			INNER JOIN 
		[{@Schema}].[CapturedPlan] CP ON MI.CapturedPlan_id = CP.CapturedPlan_id;