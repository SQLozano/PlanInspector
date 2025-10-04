CREATE TABLE [{@Schema}].[StatementSetOptions]
(
  [StatementSetOptions_id] [int] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [ANSI_NULLS] [bit] NULL,
  [ANSI_PADDING] [bit] NULL,
  [ANSI_WARNINGS] [bit] NULL,
  [ARITHABORT] [bit] NULL,
  [CONCAT_NULL_YIELDS_NULL] [bit] NULL,
  [NUMERIC_ROUNDABORT] [bit] NULL,
  [QUOTED_IDENTIFIER] [bit] NULL
)