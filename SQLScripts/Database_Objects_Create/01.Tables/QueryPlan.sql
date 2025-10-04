CREATE TABLE [{@Schema}].[QueryPlan]
(
  [QueryPlan_id] [int] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [DegreeOfParallelism] [int] NULL,
  [EffectiveDegreeOfParallelism] [int] NULL,
  [NonParallelPlanReason] [nvarchar](128) NULL,
  [DOPFeedbackAdjusted] [varchar](14) NULL,
  [MemoryGrant] [bigint] NULL,
  [CachedPlanSize] [bigint] NULL,
  [CompileTime] [bigint] NULL,
  [CompileCPU] [bigint] NULL,
  [CompileMemory] [bigint] NULL,
  [UsePlan] [bit] NULL,
  [ContainsInterleavedExecutionCandidates] [bit] NULL,
  [ContainsInlineScalarTsqlUdfs] [bit] NULL,
  [QueryVariantID] [int] NULL,
  [DispatcherPlanHandle] [nchar](10) NULL,
  [ExclusiveProfileTimeActive] [bit] NULL
)