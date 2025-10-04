CREATE VIEW [{@Schema}].[vw_Multiple_Plans_Per_QueryHash]
AS
  SELECT
     cp.[query_hash]
    ,ss.QueryHash
    ,COUNT(DISTINCT QueryPlanHash) AS PlanCount
  FROM 
    [{@Schema}].[CapturedPlan] cp
      INNER JOIN 
    [{@Schema}].[StmtSimple] ss ON cp.CapturedPlan_id = ss.CapturedPlan_id
  GROUP BY 
     QueryHash
    ,cp.[query_hash] 
  HAVING  
    COUNT(DISTINCT QueryPlanHash) > 1;