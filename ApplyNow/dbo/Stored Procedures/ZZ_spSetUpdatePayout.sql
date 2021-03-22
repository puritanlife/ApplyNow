




CREATE PROCEDURE [dbo].[ZZ_spSetUpdatePayout]
(
	  @PayoutID int = null,
      @Status [nvarchar](50) null,
	  @StripePayoutID [nvarchar](100) null,
      @PayoutPaidDate  [datetime]= null,
      @PayoutFailureDate [datetime] = null,
      @PayoutFailureReason [nvarchar](100) null,
	  @Amount int null
)
AS
BEGIN
/*************************************************
  Author:      Poonam K
  Create Date: 11/23/2020
  Description: Update a Payout schedule Data Elements Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetUpdatePayout]' 
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

	 
	set @Record_Exists = isnull((select 'Yes' from [dbo].[tblPayout] tblPSDE with(nolock) where isnull(tblPSDE.[StripePayoutID],'') = isnull(@StripePayoutID,'') ),'No')

	SET @Parameters = ' @PayoutID ' + cast(@PayoutID as nvarchar) + 
					  ' @Status ' + cast(@Status as nvarchar) + 
	                  ' @PayoutPaidDate ' + cast(@PayoutPaidDate as nvarchar) + 
	                  ' @PayoutFailureDate ' + cast(@PayoutFailureDate as nvarchar) + 
					  ' @PayoutFailureReason ' + cast(@PayoutFailureReason as nvarchar) + 
					  ' @Amount ' + cast(@Amount as nvarchar) + 
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

				update [dbo].[tblPayout]
				set [Status] = @Status
				  ,[PayoutPaidDate] = @PayoutPaidDate
				  ,[PayoutFailureDate] = @PayoutFailureDate
				  ,[PayoutFailureReason] = @PayoutFailureReason
				  ,[Amount] = @Amount			
				where [StripePayoutID] = @StripePayoutID;
				

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


	SELECT @StripePayoutID AS [StripePayoutID]
	set @Output = '@StripePayoutID ' + cast(@StripePayoutID as nvarchar)

	SET @Message = @Message + 'Record is updates. '

	EXEC [maint].[spSetLogStoredProcedureCalls]
	@Procedure = @Procedure,
	@Message = @Message,
	@Parameters = @Parameters,
	@Output = @Output,
	@StartSPCall = @StartSPCall

END