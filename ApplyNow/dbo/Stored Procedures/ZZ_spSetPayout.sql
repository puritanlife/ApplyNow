




CREATE PROCEDURE [dbo].[ZZ_spSetPayout]
(
	  @Status [nvarchar](50) null,
      @StripePayoutID [nvarchar](100) null,
      @BalanceTransactionID [nvarchar](100) null,
	  @Amount int null
)
AS
BEGIN
/*************************************************
  Author:      Poonam K
  Create Date: 11/23/2020
  Description: Inserts a Charge schedule Data Elements Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetPayout]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 
	DECLARE @PayoutID INT = NULL
	DECLARE @PayoutCreatedDate DATETIME = getdate()

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @Record_Exists nvarchar(3) = 'No'
	DECLARE @Record_Exists1 nvarchar(3) = 'No'

	if @PayoutID is null 
		set @PayoutID = -99

	if @PayoutCreatedDate is null 
		set @PayoutCreatedDate = getdate()

	if @BalanceTransactionID is null 
		set @BalanceTransactionID = 0

	if @StripePayoutID is null 
		set @StripePayoutID = 0

	if @Amount is null 
		set @Amount = 0

    set @Record_Exists = isnull((select 'Yes' from [dbo].[tblPayout] tblPSDE with(nolock) where isnull(tblPSDE.[StripePayoutID],'') = isnull(@StripePayoutID,'')),'No')

	SET @Parameters = ' @Status ' + cast(@Status as nvarchar) + 
	                  ' @StripePayoutID ' + cast(@StripePayoutID as nvarchar) + 
	                  ' @PayoutCreatedDate ' + cast(@PayoutCreatedDate as nvarchar) + 
	               	  ' @Amount ' + cast(@Amount as nvarchar) + 
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblPayout]
					([Status]
					  ,[StripePayoutID]
					  ,[PayoutCreatedDate]
					  ,[Amount]
					)
				VALUES
					(@Status				-- Status
					,@StripePayoutID		-- Charged
					,GETDATE()			-- PayoutCreatedDate
					,@Amount)
					

						SET @PayoutID = isnull((SELECT [PayoutID]
											FROM [dbo].[tblPayout] with(nolock)
											where isnull([PayoutID],'') = isnull(@@IDENTITY,'')),0)
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

				SET @Message = @Message + 'Record already exsist...... '

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
	---------------------------------------Update the record in PayoutSchedule for ----------------------------
	 set @Record_Exists1 = isnull((select 'Yes' from [dbo].[tblPayoutSchedule] tblPSD with(nolock) where isnull(tblPSD.[BalanceTransactionID],'') = isnull(@BalanceTransactionID,'')),'No')
	 if @Record_Exists1 = 'Yes'
		BEGIN
			BEGIN TRY

				update tblPS
				set	tblPS.[StripePayoutID] = @StripePayoutID	
				from [dbo].[tblPayoutSchedule] tblPS										
				where [BalanceTransactionID] = @BalanceTransactionID;

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
	if @Record_Exists1 = 'No'
	BEGIN
			BEGIN TRY

				SET @Message = @Message + 'Record does not exists... '

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

	

	SELECT @PayoutID AS [PayoutID]
	set @Output = '@PayoutID ' + cast(@PayoutID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

	EXEC [maint].[spSetLogStoredProcedureCalls]
	@Procedure = @Procedure,
	@Message = @Message,
	@Parameters = @Parameters,
	@Output = @Output,
	@StartSPCall = @StartSPCall

END