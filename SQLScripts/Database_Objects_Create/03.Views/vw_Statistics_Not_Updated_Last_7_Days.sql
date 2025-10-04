CREATE VIEW [{@Schema}].[vw_Statistics_Not_Updated_Last_7_Days]
AS
SELECT Distinct
	 [Database]
	,[Schema]
	,[Table]
	,[Statistics]
	,[ModificationCount]
	,[SamplingPercent]
	,[LastUpdate]
FROM
	[{@Schema}].[StatisticsInfo] 
WHERE
	[Schema] <> '[sys]' AND
	[Database] NOT IN ('[msdb]','[master]') AND 
	[ModificationCount] > 0 AND 
	LastUpdate < (DATEADD(day, -7,(SELECT GETDATE())));