CREATE VIEW [{@Schema}].[vw_Actual]
AS 
  SELECT 
    [{@Schema}].[Relop].[CapturedPlan_id],
    [{@Schema}].[RunTimeCountersPerThread].[Thread_id],
    [{@Schema}].[Relop].[PhysicalOp],
    SUM([{@Schema}].[RunTimeCountersPerThread].[ActualRows]) AS [Sum_ActualRows],
    COALESCE ([{@Schema}].[Relop].[EstimateNumberOfRowsForAllExecutions],[{@Schema}].[Relop].[EstimateRows]) AS [Sum_EstimateRows],
    [{@Schema}].[Relop].[EstimateRows],
    [{@Schema}].[Relop].[EstimateNumberOfExecutions],
    [{@Schema}].[Relop].[EstimateNumberOfRowsForAllExecutions],
    CASE 
      WHEN SUM([{@Schema}].[RunTimeCountersPerThread].[ActualRows]) = 0 THEN 0
        ELSE 100/(SUM([{@Schema}].[RunTimeCountersPerThread].[ActualRows])) *  (COALESCE ([{@Schema}].[Relop].[EstimateNumberOfRowsForAllExecutions],[{@Schema}].[Relop].[EstimateRows],0)) 
      END AS [perc1],
    [{@Schema}].[StmtSimple].[QueryHash],
    [{@Schema}].[StmtSimple].[QueryPlanHash]
  FROM 
    [{@Schema}].[RunTimeCountersPerThread] 
    INNER JOIN [{@Schema}].[Relop] 
    ON  [{@Schema}].[RunTimeCountersPerThread].Relop_id = [{@Schema}].[Relop].Relop_id 
    AND [{@Schema}].[RunTimeCountersPerThread].[CapturedPlan_id] = [{@Schema}].[Relop].[CapturedPlan_id] 
    INNER JOIN [{@Schema}].[StmtSimple] 
    ON [{@Schema}].[StmtSimple].CapturedPlan_id = [{@Schema}].[Relop].[CapturedPlan_id]
  GROUP BY 
    [{@Schema}].[Relop].[CapturedPlan_id],
    [{@Schema}].[RunTimeCountersPerThread].[Relop_id],
    [{@Schema}].[RunTimeCountersPerThread].[Thread_id],
    [{@Schema}].[Relop].[PhysicalOp],
    [{@Schema}].[Relop].[EstimateRows],
    [{@Schema}].[StmtSimple].[QueryHash],
    [{@Schema}].[StmtSimple].[QueryPlanHash],
    [{@Schema}].[Relop].[EstimateNumberOfRowsForAllExecutions],
    [{@Schema}].[Relop].[EstimateNumberOfExecutions]