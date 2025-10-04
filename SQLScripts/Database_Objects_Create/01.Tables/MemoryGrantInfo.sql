CREATE TABLE [{@Schema}].[MemoryGrantInfo]
(
  [MemoryGrantInfo_id] [int] IDENTITY(1,1) NOT NULL,
  [CapturedPlan_id] [int] NOT NULL,
  [SerialRequiredMemory] [bigint] NOT NULL,
  [SerialDesiredMemory] [bigint] NOT NULL,
  [RequiredMemory] [bigint] NULL,
  [DesiredMemory] [bigint] NULL,
  [RequestedMemory] [bigint] NULL,
  [GrantWaitTime] [bigint] NULL,
  [GrantedMemory] [bigint] NULL,
  [MaxUsedMemory] [bigint] NULL,
  [MaxQueryMemory] [bigint] NULL,
  [LastRequestedMemory] [bigint] NULL,
  [IsMemoryGrantFeedbackAdjusted] [varchar] (25) NULL
)