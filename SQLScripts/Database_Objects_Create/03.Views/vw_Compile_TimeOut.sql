CREATE VIEW [{@Schema}].[vw_Compile_TimeOut]
AS
    SELECT
      s.[CapturedPlan_id]
      ,s.[StatementEstRows]
      ,s.[StatementOptmLevel]
      ,s.[StatementOptmEarlyAbortReason]
      ,s.[CardinalityEstimationModelVersion]
      ,s.[StatementSubTreeCost]
      ,qpi.[CachedPlanSize]
      ,qpi.[CompileTime]
      ,qpi.[CompileCPU]
      ,qpi.[CompileMemory]
      ,TRY_CONVERT(XML,DECOMPRESS(CP.showplan_xml_compressed)) [showplan_xml]
      ,cp.sql_text
    FROM
      [{@Schema}].[StmtSimple] s INNER JOIN
      [{@Schema}].[QueryPlan] qpi ON s.CapturedPlan_id = qpi.CapturedPlan_id INNER JOIN
      [{@Schema}].[CapturedPlan] cp ON s.CapturedPlan_id = cp.CapturedPlan_id
    WHERE
    StatementOptmEarlyAbortReason IN ('MemoryLimitExceeded','TimeOut')