CREATE TABLE [{@Schema}].[WaitStats](
  [WaitStat_id] [int] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [WaitType] [nvarchar](128) NOT NULL,
  [WaitTimeMs] [bigint] NOT NULL,
  [WaitCount] [bigint] NULL
)