CREATE TABLE [{@Schema}].[StatisticsInfo]
(
  [StatisticsInfo_id] [int] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [Database] [nvarchar](256) NULL,
  [Schema] [nvarchar](256) NULL,
  [Table] [nvarchar](256) NULL,
  [Statistics] [nvarchar](256) NULL,
  [ModificationCount] [bigint] NULL,
  [SamplingPercent] [float] NULL,
  [LastUpdate] [DateTime] NULL
) 