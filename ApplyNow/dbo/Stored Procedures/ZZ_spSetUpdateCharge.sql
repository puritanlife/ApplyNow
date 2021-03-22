




CREATE PROCEDURE [dbo].[ZZ_spSetUpdateCharge]
(
	  @ChargeID int = null,  
      @Status [nvarchar](50) null,
	  @StripeChargeID [nvarchar](100) null,
      @ChargeSuccessDate [datetime] = null,
      @ChargeFailureDate [datetime] = null,
      @ChargeFailureReason [nvarchar](1000) null,
      @Amount int null
)
AS
BEGIN
/*************************************************
  Author:      Poonam K
  Create Date: 11/23/2020
  Description: Update a Charge schedule Data Elements Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetUpdateCharge]' 
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

	 
	set @Record_Exists = isnull((select 'Yes' from [dbo].[tblCharge] tblPSDE with(nolock) where isnull(tblPSDE.[StripeChargeID],'') = isnull(@StripeChargeID,'')),'No')

	SET @Parameters = ' @ChargeID ' + cast(@ChargeID as nvarchar) + 
					  ' @Status ' + cast(@Status as nvarchar) + 
	                  ' @ChargeSuccessDate ' + cast(@ChargeSuccessDate as nvarchar) + 
	                  ' @ChargeFailureDate ' + cast(@ChargeFailureDate as nvarchar) + 
					  ' @ChargeFailureReason ' + cast(@ChargeFailureReason as nvarchar) + 
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

				update [dbo].[tblCharge]
				set [Status] = @Status
				  ,[ChargeSuccessDate] = @ChargeSuccessDate				  
				  ,[ChargeFailureDate] = @ChargeFailureDate
				  ,[ChargeFailureReason] = @ChargeFailureReason
				  ,[Amount] = @Amount			
				where [StripeChargeID] = @StripeChargeID;


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


	SELECT @StripeChargeID AS [StripeChargeID]
	set @Output = '@StripeChargeID ' + cast(@StripeChargeID as nvarchar)

	SET @Message = @Message + 'Record is updates. '

	EXEC [maint].[spSetLogStoredProcedureCalls]
	@Procedure = @Procedure,
	@Message = @Message,
	@Parameters = @Parameters,
	@Output = @Output,
	@StartSPCall = @StartSPCall

END