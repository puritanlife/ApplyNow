
CREATE procedure [dbo].[spRemoveApplyNowPerson]
(
	@ApplyNowID [int] null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/9/2020
  Description: Deletes an ApplyNow Record.
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spRemoveApplyNowPerson]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @ExistingPolicy_RecordExists nvarchar(3) = 'No'
	DECLARE @DocuSignDataElements_RecordExists nvarchar(3) = 'No'
	DECLARE @LexisNexisDataElements_RecordExists nvarchar(3) = 'No'
	DECLARE @PlaidStripeDataElements_RecordExits nvarchar(3) = 'No'
	DECLARE @ApplyNow_RecordExists nvarchar(3) = 'No'

	if @ApplyNowID is null 
		set @ApplyNowID = isnull(@ApplyNowID,-99);
		
	if @ApplyNowID <> -99 
		set @ExistingPolicy_RecordExists = isnull((select 'Yes' from [dbo].[tblExistingPolicy] with(nolock) where isnull([ApplyNowID],'') = isnull(@ApplyNowID,'')),'No');
		set @DocuSignDataElements_RecordExists = isnull((select 'Yes' from [dbo].[tblDocuSignDataElements] with(nolock) where isnull([ApplyNowID],'') = isnull(@ApplyNowID,'')),'No');
		set @LexisNexisDataElements_RecordExists = isnull((select 'Yes' from [dbo].[tblLexisNexisDataElements] with(nolock) where isnull([ApplyNowID],'') = isnull(@ApplyNowID,'')),'No');
		set @PlaidStripeDataElements_RecordExits = isnull((select 'Yes' from [dbo].[tblPlaidStripeDataElements] with(nolock) where isnull([ApplyNowID],'') = isnull(@ApplyNowID,'')),'No');
		set @ApplyNow_RecordExists = isnull((select 'Yes' from [dbo].[tblApplyNow] with(nolock) where isnull([ApplyNowID],'') = isnull(@ApplyNowID,'')),'No');
		
	SET @Parameters = '@ApplyNowID ' + cast(@ApplyNowID as nvarchar) + 
					  ' @ExistingPolicy_RecordExists ' + cast(@ExistingPolicy_RecordExists as nvarchar) +  
					  ' @DocuSignDataElements_RecordExists ' + cast(@DocuSignDataElements_RecordExists as nvarchar) + 
					  ' @LexisNexisDataElements_RecordExists ' + cast(@LexisNexisDataElements_RecordExists as nvarchar) + 
					  ' @PlaidStripeDataElements_RecordExits ' + cast(@PlaidStripeDataElements_RecordExits as nvarchar) + 
					  ' @ApplyNow_RecordExists ' + cast(@ApplyNow_RecordExists as nvarchar)

	if @ExistingPolicy_RecordExists = 'Yes'
		BEGIN
			BEGIN TRY

				delete from [dbo].[tblExistingPolicy] where [ApplyNowID] = @ApplyNowID;

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

	if @DocuSignDataElements_RecordExists = 'Yes'
		BEGIN
			BEGIN TRY

				delete from [dbo].[tblDocuSignDataElements] where [ApplyNowID] = @ApplyNowID;

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

	if @LexisNexisDataElements_RecordExists = 'Yes'
		BEGIN
			BEGIN TRY

				delete from [dbo].[tblLexisNexisDataElements] where [ApplyNowID] = @ApplyNowID;

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

	if @PlaidStripeDataElements_RecordExits = 'Yes'
		BEGIN
			BEGIN TRY

				delete from [dbo].[tblPlaidStripeDataElements] where [ApplyNowID] = @ApplyNowID;

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

	if @ApplyNow_RecordExists = 'Yes'
		BEGIN
			BEGIN TRY

				delete from [dbo].[tblApplyNow] where [ApplyNowID] = @ApplyNowID;

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
		
    select @ApplyNowID AS 'ApplyNowID'
	SET @Output = 'ApplyNowID ' + cast(@ApplyNowID as nvarchar)
	SET @Message = @Message + 'Deletes records. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END