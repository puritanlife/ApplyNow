


CREATE PROCEDURE [dbo].[spSetUpdateACHTransactionInfo]
(
	  @TransactionReferenceID [nvarchar](1000) null,
	  @TransactionStatus [nvarchar](500) null
)
AS
BEGIN
/*************************************************
  Author:      Poonam K
  Create Date: 01/12/2021
  Description: Update a ACH Transaction Status.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetUpdateACHTransactionInfo]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

		-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @Record_Exists nvarchar(3) = 'No'

	 
	set @Record_Exists = isnull((select 'Yes' from [dbo].[tblACHPaymentInfo] tblACHU with(nolock) where isnull(tblACHU.[TransactionReferenceID],'') = isnull(@TransactionReferenceID,'') ),'No')

	SET @Parameters = ' @TransactionStatus ' + cast(@TransactionStatus as nvarchar) + 
					  ' @TransactionReferenceID ' + cast(@TransactionReferenceID as nvarchar) + 
	                  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
	BEGIN
			BEGIN TRY

			SET @Message = @Message + 'Record does not exsist '	
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

				update [dbo].[tblACHPaymentInfo]
				set  [TransactionStatusUpdatedDate] = getdate()
					,[TransactionStatus] = @TransactionStatus					 
				where [TransactionReferenceID] = @TransactionReferenceID;
				

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


	SELECT @TransactionReferenceID AS [TransactionReferenceID]
	set @Output = '@TransactionReferenceID ' + cast(@TransactionReferenceID as nvarchar)

	SET @Message = @Message + 'Record is updates. '

	EXEC [maint].[spSetLogStoredProcedureCalls]
	@Procedure = @Procedure,
	@Message = @Message,
	@Parameters = @Parameters,
	@Output = @Output,
	@StartSPCall = @StartSPCall

END