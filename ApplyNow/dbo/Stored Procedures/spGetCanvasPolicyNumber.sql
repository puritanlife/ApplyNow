
CREATE procedure [dbo].[spGetCanvasPolicyNumber]
(
    @ApplicationID [int] null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/21/2020
  Description: Returns an application's canvas policy number. 
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetCanvasPolicyNumber]' 
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
	DECLARE @Parameters nvarchar(max) = '@ApplicationID ' + cast(@ApplicationID as nvarchar)

	SELECT tblA.[CanvasPolicyNumber]
	FROM [dbo].[tblApplication] tblA with(nolock)
	where isnull(tblA.[ApplicationID],'') = isnull(@ApplicationID, tblA.[ApplicationID])
	and isnull(tblA.[CanvasPolicyNumber],'') <> ''
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