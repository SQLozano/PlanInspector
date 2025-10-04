CREATE TABLE [{@Schema}].[QueryTimeStats]
(
  [QueryTimeStats_id] [int] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [CpuTime] [bigint] NULL,
  [ElapsedTime] [bigint] NULL,
  [UdfCpuTime] [bigint] NULL,
  [UdfElapsedTime] [bigint] NULL
) 