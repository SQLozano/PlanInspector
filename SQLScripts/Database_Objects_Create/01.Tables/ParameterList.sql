CREATE TABLE [{@Schema}].[ParameterList]
(
  [ParameterList_id] [int] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [Column] [nvarchar](128) NOT NULL,
  [ParameterDataType] [nvarchar](128) NOT NULL,
  [ParameterCompiledValue] [nvarchar](max) NULL,
  [ParameterRuntimeValue] [nvarchar](max) NULL
) 