CREATE OR ALTER PROCEDURE [{@Schema}].[CompressData]
(
 @CapturedPlan_id BIGINT
,@Verbose BIT = 0
)
AS
SET NOCOUNT ON
IF NOT EXISTS (SELECT 1 FROM [{@Schema}].[CapturedPlan] WHERE [CapturedPlan_id] = @CapturedPlan_id)
BEGIN	
	PRINT 'No captured plan @CapturedPlan_id = ' + QUOTENAME(@CapturedPlan_Id) + ' could be found' 
	RETURN
END
DECLARE @showplan_xml_compressed	VARBINARY(MAX)
DECLARE @sql_text_compressed		VARBINARY(MAX)

SELECT 
	 @showplan_xml_compressed	=	COALESCE(COMPRESS([showplan_xml]), [showplan_xml_compressed])
	,@sql_text_compressed		=	COALESCE(COMPRESS([sql_text]), [sql_text_compressed])
FROM [{@Schema}].[CapturedPlan]
WHERE [CapturedPlan_id] = @CapturedPlan_id

UPDATE [{@Schema}].[CapturedPlan]
SET
	 [showplan_xml]					=	NULL
	,[showplan_xml_compressed]		=	@showplan_xml_compressed
	,[sql_text]						=	NULL
	,[sql_text_compressed]			=	@sql_text_compressed
WHERE [CapturedPlan_id] = @CapturedPlan_id