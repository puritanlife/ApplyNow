
CREATE procedure [dbo].[spGetLexisNexisDataElements]
(
    @LexisNexisDataElementsID [int] null ,
    @ApplyNowID [int] null,
    @LexisNexisCallTypeID [int] null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/5/2020
  Description: Returns all person's associated lexis nexis with application data. 
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetLexisNexisDataElements]' 
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
	DECLARE @Parameters nvarchar(max) = null

	SET @Parameters = '@LexisNexisDataElementsID ' + cast(@LexisNexisDataElementsID as nvarchar) + 
	                  ' @ApplyNowID ' + cast(@ApplyNowID as nvarchar) + 
					  ' @LexisNexisCallTypeID ' + cast(@LexisNexisCallTypeID as nvarchar)

	SELECT 
		 tblLNDE.[LexisNexisDataElementsID] AS [LexisNexisDataElementsID]
		,tblLNDE.[ApplyNowID] AS [ApplyNowID]
		,tblLNDE.[ConversationID] AS [ConversationID]
		,tblLNDE.[LexisNexisCallTypeID] AS [LexisNexisCallTypeID]
		,tblLNCT.[Type] AS [Type]
		,tblLNCT.[Descr] AS [Descr]
	FROM [dbo].[tblLexisNexisDataElements] tblLNDE with(nolock)
	inner join [dbo].[tblLexisNexisCallType] tblLNCT with(nolock) on tblLNCT.[LexisNexisCallTypeID] = tblLNDE.[LexisNexisCallTypeID]
	and isnull(tblLNDE.[LexisNexisDataElementsID],'') = isnull(@LexisNexisDataElementsID,tblLNDE.[LexisNexisDataElementsID])
	and isnull(tblLNDE.[ApplyNowID],'') = isnull(@ApplyNowID,tblLNDE.[ApplyNowID])
	and isnull(tblLNDE.[LexisNexisCallTypeID],'') = isnull(@LexisNexisCallTypeID,tblLNDE.[LexisNexisCallTypeID])
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