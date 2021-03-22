
CREATE procedure [dbo].[spGetAdminLoginAttempt]
(
	@AttemptDateBegin		DATE = '1900-01-01',
	@AttemptDateEnd			DATE = '9999-01-01'
) AS
BEGIN
/*************************************************
	Author:      Daniel Kelleher
	Create Date: 4/21/2020
	Description: Obtains a list of admin login attempts by attempt start and end date.
*************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetAdminLoginAttempt]' 
	DECLARE @Error nvarchar(max) = null 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 
	DECLARE @SP_RowCount int = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = '@AttemptDateBegin ' + cast(@AttemptDateBegin as nvarchar) + ' @AttemptDateEnd ' + cast(@AttemptDateEnd as nvarchar)

	SELECT 
	 [Email]			AS [Email]
	,[SuccessFlag]		AS [SuccessFlag]
	,[AttemptDate]		AS [AttemptDate]
	,[AttemptMessage]	AS [AttemptMessage]
	FROM [dbo].[tblAdminLoginAttempt] ra with(nolock)
	WHERE cast(ra.[AttemptDate] as date) >= cast(@AttemptDateBegin as date)
	AND  cast(ra.[AttemptDate] as date) <= cast(@AttemptDateEnd as date)
	ORDER BY ra.[AttemptDate] DESC
	SET @SP_RowCount = @@ROWCOUNT;
	
	SET @Message = @Message + 'Select only, not inserts or updates. '
	SET @Output = @Output + 'Record Count ' + cast(@SP_RowCount as varchar)
	
    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END