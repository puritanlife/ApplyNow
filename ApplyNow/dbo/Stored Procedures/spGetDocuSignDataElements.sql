
CREATE procedure [dbo].[spGetDocuSignDataElements]
(
    @DocuSignDataElementsID [int] null ,
    @ApplyNowID [int] null,
    @Signature [bit] null
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
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetDocuSignDataElements]' 
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

	SET @Parameters = '@DocuSignDataElementsID ' + cast(@DocuSignDataElementsID as nvarchar) + 
	                  ' @ApplyNowID ' + cast(@ApplyNowID as nvarchar) + 
					  ' @Signature ' + cast(@Signature as nvarchar)

	SELECT tblLNDE.[DocuSignDataElementsID] AS [DocuSignDataElementsID]
		  ,tblLNDE.[ApplyNowID] AS [ApplyNowID]
		  ,tblLNDE.[Signature] AS [Signature]
    FROM [dbo].[tblDocuSignDataElements] tblLNDE with(nolock)
	where isnull(tblLNDE.[DocuSignDataElementsID],'') = isnull(@DocuSignDataElementsID,tblLNDE.[DocuSignDataElementsID])
	and isnull(tblLNDE.[ApplyNowID],'') = isnull(@ApplyNowID,tblLNDE.[ApplyNowID])
	and isnull(tblLNDE.[Signature],'') = isnull(@Signature,tblLNDE.[Signature])
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