CREATE TABLE [{@Schema}].[TraceFlag]
(
  [TraceFlag_id] [int] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [Value] [int] NOT NULL,
  [Scope] [nvarchar] (256) NOT NULL
)