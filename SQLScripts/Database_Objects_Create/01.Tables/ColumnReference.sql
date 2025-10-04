CREATE TABLE [{@Schema}].[ColumnReference](
  [ColumnReference_ID] [bigint] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [Database] [nvarchar](128) NOT NULL,
  [Schema] [nvarchar](128) NOT NULL,
  [Table] [nvarchar](128) NOT NULL,
  [Column] [nvarchar](128) NOT NULL
)