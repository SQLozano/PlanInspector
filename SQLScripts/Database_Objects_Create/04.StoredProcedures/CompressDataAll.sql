CREATE OR ALTER PROCEDURE [{@Schema}].[CompressDataAll]
(
 @Verbose BIT = 0
)
AS
SET NOCOUNT ON
DECLARE @CapturedPlan_ID	BIGINT

DECLARE [CapturedPlan_Cursor] CURSOR LOCAL FAST_FORWARD
FOR
SELECT [CapturedPlan_id] FROM [{@Schema}].[CapturedPlan]
WHERE [showplan_xml] IS NOT NULL
OR [sql_text] IS NOT NULL
ORDER BY [CapturedPlan_id] ASC

OPEN [CapturedPlan_Cursor]
FETCH NEXT FROM [CapturedPlan_Cursor] INTO @CapturedPlan_ID
WHILE (@@fetch_status >= 0)
BEGIN
	EXECUTE [{@Schema}].[CompressData] @CapturedPlan_id = @CapturedPlan_id, @Verbose = @Verbose
	FETCH NEXT FROM [CapturedPlan_Cursor] INTO @CapturedPlan_ID
END

CLOSE [CapturedPlan_Cursor]
DEALLOCATE [CapturedPlan_Cursor]