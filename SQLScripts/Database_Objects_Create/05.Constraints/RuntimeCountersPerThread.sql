ALTER TABLE [{@Schema}].[RunTimeCountersPerThread] ADD CONSTRAINT [PK_RunTimeCountersPerThread] PRIMARY KEY CLUSTERED ([CapturedPlan_id],[Relop_id],[Thread_id])
ALTER TABLE [{@Schema}].[RunTimeCountersPerThread] ADD CONSTRAINT [FK_RunTimeCountersPerThread_Relop_id] FOREIGN KEY ([Relop_id]) REFERENCES [{@Schema}].[Relop]([Relop_id])
ALTER TABLE [{@Schema}].[RunTimeCountersPerThread] ADD CONSTRAINT [FK_RunTimeCountersPerThread_CapturedPlan_id] FOREIGN KEY ([CapturedPlan_id]) REFERENCES [{@Schema}].[CapturedPlan]([CapturedPlan_id])
ALTER TABLE [{@Schema}].[RunTimeCountersPerThread] ADD CONSTRAINT [CK_RunTimeCountersPerThread_ActualExecutionMode] CHECK
(
    (
        [ActualExecutionMode]='Row' OR [ActualExecutionMode]='Batch'
    )
)