ALTER TABLE [{@Schema}].[MemoryGrantInfo] ADD CONSTRAINT [PK_MemoryGrantInfo] PRIMARY KEY CLUSTERED ([MemoryGrantInfo_id])
ALTER TABLE [{@Schema}].[MemoryGrantInfo] ADD CONSTRAINT [FK_MemoryGrantInfo_CapturedPlan_id] FOREIGN KEY ([CapturedPlan_id]) REFERENCES [{@Schema}].[CapturedPlan]([CapturedPlan_id])
ALTER TABLE [{@Schema}].[MemoryGrantInfo] ADD CONSTRAINT [CK_IsMemoryGrantFeedbackAdjusted] CHECK 
(
    (
        [IsMemoryGrantFeedbackAdjusted]='Yes: Percentile Adjusting' OR 
        [IsMemoryGrantFeedbackAdjusted]='No: Feedback Disabled' OR 
        [IsMemoryGrantFeedbackAdjusted]='No: Accurate Grant' OR 
        [IsMemoryGrantFeedbackAdjusted]='No: First Execution' OR 
        [IsMemoryGrantFeedbackAdjusted]='Yes: Stable' OR 
        [IsMemoryGrantFeedbackAdjusted]='Yes: Adjusting'
    )
)