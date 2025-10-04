CREATE VIEW [{@Schema}].[vw_Hashes]
AS 
	SELECT
		 cp.[CapturedPlan_id]
		,cp.[query_hash]
		,ss.[QueryHash]
		,cp.[query_plan_hash]
		,ss.[QueryPlanHash]
	FROM 
		[{@Schema}].[CapturedPlan] cp
			INNER JOIN 
		[{@Schema}].[StmtSimple] ss ON cp.CapturedPlan_id = ss.CapturedPlan_id