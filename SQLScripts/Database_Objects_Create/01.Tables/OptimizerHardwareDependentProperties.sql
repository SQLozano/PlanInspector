CREATE TABLE [{@Schema}].[OptimizerHardwareDependentProperties]
(
  [OptimizerHardwareDependentProperties_id] [int] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [EstimatedAvailableMemoryGrant] [bigint] NULL,
  [EstimatedPagesCached] [bigint] NULL,
  [EstimatedAvailableDegreeOfParallelism] [bigint] NULL,
  [MaxCompileMemory] [bigint] NULL
)