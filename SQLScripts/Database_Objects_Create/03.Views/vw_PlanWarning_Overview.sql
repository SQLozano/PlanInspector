CREATE VIEW [{@Schema}].[vw_PlanWarning_Overview]
		AS
		SELECT
			 SUM(TRY_CONVERT(int,[IsSpillOccurred]))              AS [IsSpillOccurred]
			,SUM(TRY_CONVERT(int,[IsColumnsWithNoStatistics]))    AS [IsColumnsWithNoStatistics]
			,SUM(TRY_CONVERT(int,[IsColumnsWithStaleStatistics])) AS [IsColumnsWithStaleStatistics]
			,SUM(TRY_CONVERT(int,[IsSpillToTempDb]))              AS [IsSpillToTempDb]
			,SUM(TRY_CONVERT(int,[IsWait]))                       AS [IsWait]
			,SUM(TRY_CONVERT(int,[IsPlanAffectingConvert]))       AS [IsPlanAffectingConvert]
			,SUM(TRY_CONVERT(int,[IsSortSpillDetails]))           AS [IsSortSpillDetails]
			,SUM(TRY_CONVERT(int,[IsHashSpillDetails]))           AS [IsHashSpillDetails]
			,SUM(TRY_CONVERT(int,[IsExchangeSpillDetails]))       AS [IsExchangeSpillDetails]
			,SUM(TRY_CONVERT(int,[IsMemoryGrantWarning]))         AS [IsMemoryGrantWarning]
      ,SUM(TRY_CONVERT(int,[IsNoJoinPredicate]))            AS [IsNoJoinPredicate]
      ,SUM(TRY_CONVERT(int,[IsUnmatchedIndexes]))           AS [IsUnmatchedIndexes]
      
		FROM 
			[{@Schema}].[Warning]