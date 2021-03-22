



CREATE PROCEDURE [dbo].[ZZ_sspSetPayoutSchedule]
(
    @PayoutScheduleID [int]=null ,
	@PolicyNumber [nvarchar] (50) null ,
    @StripeChargeID [nvarchar](100) NULL ,
	@BalanceTransactionID [nvarchar](100) null,
	@Amount int null
)
AS
BEGIN
/*************************************************
  Author:      Poonam K
  Create Date: 11/23/2020
  Description: Inserts a Payout schedule Data Elements Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetPayoutSchedule]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 
	DECLARE @ChargeID nvarchar(50) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @Record_Exists nvarchar(3) = 'No'

	if @PolicyNumber is null 
		set @PolicyNumber = -99

	if @StripeChargeID is null 
		set @StripeChargeID = 0

	if @BalanceTransactionID is null 
		set @BalanceTransactionID = 0


	 set @Record_Exists = isnull((select 'Yes' from [dbo].[tblCharge] tblPSDE with(nolock) where isnull(tblPSDE.[StripeChargeID],'') = isnull(@StripeChargeID,'')),'No')

	SET @Parameters = ' @PayoutScheduleID ' + cast(@PayoutScheduleID as nvarchar) + 
	                  ' @PolicyNumber ' + cast(@PolicyNumber as nvarchar) + 
	                 ' @StripeChargeID ' + cast(@StripeChargeID as nvarchar) + 
					' @BalanceTransactionID ' + cast(@BalanceTransactionID as nvarchar) + 
					' @Amount ' + cast(@Amount as nvarchar) + 
	                  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
			-------------------------------------------Insert in Charge---------------------------------------
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblCharge]
					([Status]
					  ,[StripeChargeID]
					  ,[ChargeDate]
					  ,[Amount]
					  )
				VALUES
					('Charge-Created'	-- Status
					,@StripeChargeID	-- Charged
					,GETDATE()			-- ChargeDate					
					,@Amount
					)	

						SET @ChargeID = isnull((SELECT [ChargeID]
											FROM [dbo].[tblCharge] with(nolock)
											where isnull([ChargeID],'') = isnull(@@IDENTITY,'')),0)
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
-------------------------------------Insert the record in tblPayoutSchedule
	 set @Record_Exists = isnull((select 'Yes' from [dbo].[tblPayoutSchedule] tblPSDE with(nolock) where isnull(tblPSDE.[BalanceTransactionID],'') = isnull(@BalanceTransactionID,'')),'No')
	 if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblPayoutSchedule]
					([PolicyNumber]
					  ,[BalanceTransactionID]
					  ,[StripeChargeID])
				VALUES
					(@PolicyNumber				-- ApplyNowID
					,@BalanceTransactionID
					,@StripeChargeID)	-- PaymentMethodTypeID

					SET @PayoutScheduleID = isnull((SELECT [PayoutScheduleID]
											FROM [dbo].[tblPayoutSchedule] with(nolock)
											where isnull([BalanceTransactionID],'') = isnull(@BalanceTransactionID,'')
											and isnull([PayoutScheduleID],'') = isnull(@@IDENTITY,'')),0)
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
		---------------------------------------------------------------Update Table [tblPayoutSchedule] once ChargeID is created for BalanceTransactionID
		BEGIN
			BEGIN TRY

				SET @Message = @Message + 'Record Already exsist in tblPayoutSchedule '

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


	SELECT @PayoutScheduleID AS [PayoutScheduleID]
	set @Output = '@PayoutScheduleID ' + cast(@PayoutScheduleID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

	EXEC [maint].[spSetLogStoredProcedureCalls]
	@Procedure = @Procedure,
	@Message = @Message,
	@Parameters = @Parameters,
	@Output = @Output,
	@StartSPCall = @StartSPCall

END