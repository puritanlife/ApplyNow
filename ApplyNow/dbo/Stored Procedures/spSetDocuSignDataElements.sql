
CREATE procedure [dbo].[spSetDocuSignDataElements]
(
    @DocuSignDataElementsID [int] null ,
	@ApplyNowID [int] null ,
    @Signature [bit] null 
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/12/2020
  Description: Inserts a DocuSign Data Elements Record.
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetDocuSignDataElements]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @Record_Exists nvarchar(max) = 'No'

	if @ApplyNowID is null 
		set @ApplyNowID = -99

	if @Signature is null 
		set @Signature = 0
					
	if @DocuSignDataElementsID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblDocuSignDataElements] with(nolock) where isnull([DocuSignDataElementsID],'') = isnull(@DocuSignDataElementsID,'')),'No');

	SET @Parameters = '@DocuSignDataElementsID ' + cast(@DocuSignDataElementsID as nvarchar) + 
	                  ' @ApplyNowID ' + cast(@ApplyNowID as nvarchar) + 
	                  ' @Signature ' + cast(@Signature as nvarchar) + 
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN

			BEGIN TRY

				INSERT INTO [dbo].[tblDocuSignDataElements]
							([ApplyNowID]
							,[Signature])
						VALUES
							(@ApplyNowID		-- ApplyNowID
							,@Signature)		-- Signature

			END TRY
			BEGIN CATCH  

				SELECT  
					 @ErrorNumber = ERROR_NUMBER()
					,@ErrorSeverity = ERROR_SEVERITY()
					,@ErrorState = ERROR_STATE()
					,@ErrorProcedure = ERROR_PROCEDURE()
					,@ErrorMessage = ERROR_MESSAGE();

				EXEC [maint].[spSetLogCatchingErrors]
					@ErrorNumber = @ErrorNumber,
					@ErrorSeverity = @ErrorSeverity,
					@ErrorState = @ErrorState,
					@ErrorProcedure = @Procedure,
					@ErrorMessage = @ErrorMessage,
					@ErrorParameters = @Parameters

			END CATCH;  

		END;
		
	if @Record_Exists = 'Yes'
		BEGIN

			BEGIN TRY

				Update [dbo].[tblDocuSignDataElements]
					set [ApplyNowID] = @ApplyNowID
						,[Signature] = @Signature
				where [DocuSignDataElementsID] = @DocuSignDataElementsID

			END TRY
			BEGIN CATCH  

				SELECT  
					 @ErrorNumber = ERROR_NUMBER()
					,@ErrorSeverity = ERROR_SEVERITY()
					,@ErrorState = ERROR_STATE()
					,@ErrorProcedure = ERROR_PROCEDURE()
					,@ErrorMessage = ERROR_MESSAGE();

				EXEC [maint].[spSetLogCatchingErrors]
					@ErrorNumber = @ErrorNumber,
					@ErrorSeverity = @ErrorSeverity,
					@ErrorState = @ErrorState,
					@ErrorProcedure = @Procedure,
					@ErrorMessage = @ErrorMessage,
					@ErrorParameters = @Parameters

			END CATCH;  

		END;
		
	set @DocuSignDataElementsID = isnull((select [DocuSignDataElementsID] from [dbo].[tblDocuSignDataElements] with(nolock) 
																			where isnull([ApplyNowID],'') = isnull(@ApplyNowID,'')
																			and  isnull([Signature],'') = isnull(@Signature,'')),-99);
	
    select @DocuSignDataElementsID AS DocuSignDataElementsID 
	set @Output = '@DocuSignDataElementsID ' + cast(@DocuSignDataElementsID as nvarchar)
   
	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END