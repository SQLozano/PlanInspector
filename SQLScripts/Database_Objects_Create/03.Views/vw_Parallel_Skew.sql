CREATE VIEW [{@Schema}].[vw_Parallel_Skew] 
AS 
SELECT 
    R.[CapturedPlan_id],
    RTC.[NodeId],
		RTC.[Thread],
    RTC.[ActualRows],
		/*Calculate how much rows were handled per thread compared to the total of the operator*/
    CAST(
    ROUND(
        RTC.[ActualRows] / 
        (
            SELECT 
                CASE 
                    WHEN SUM([ActualRows]) = 0 THEN 1 /* Avoid divide by zero by using 1 as the denominator*/
                    ELSE SUM([ActualRows])
                END
            FROM 
                [{@Schema}].[RunTimeCountersPerThread] RTC2
            WHERE 
                RTC2.relop_id = RTC.Relop_id
            GROUP BY  
                RTC2.[Relop_id],
                RTC2.[NodeId]
        ) * 100, 2
    ) AS DECIMAL(18,2)
) AS [Percentage]
FROM 
    [{@Schema}].[RunTimeCountersPerThread] RTC
    INNER JOIN 
    [{@Schema}].[Relop] R 
    ON RTC.[Relop_id] = R.[Relop_id] AND RTC.CapturedPlan_id = R.CapturedPlan_id
WHERE 
    RTC.ActualRows IS NOT NULL AND /*only operators who returned rows*/
    RTC.Thread > 0 AND /*Thread 0 is always 0*/
		R.Parallel = 1 /*Only parrellel operators*/
GROUP BY 
    R.[CapturedPlan_id],
    RTC.[NodeId],
    RTC.[ActualRows],
    RTC.[Thread],
    RTC.[Relop_id];