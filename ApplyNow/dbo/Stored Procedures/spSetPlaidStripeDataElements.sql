
CREATE procedure [dbo].[spSetPlaidStripeDataElements]
(
    @PlaidStripeDataElementsID [int] null ,
	@ApplyNowID [int] null ,
    @Charged [bit] null ,
	@PlaidStripeID nvarchar(250) null,
	@PaymentAmount [float] null ,
	@PaymentMethodTypeID [int] null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/12/2020
  Description: Inserts a Plaid Stripe Data Elements Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetPlaidStripeDataElements]' 
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

	if @ApplyNowID is null 
		set @ApplyNowID = -99

	if @Charged is null 
		set @Charged = 0

	if @PaymentAmount is null 
		set @PaymentAmount = 0

    if @PlaidStripeDataElementsID <> -99
	  set @Record_Exists = isnull((select 'Yes' from [dbo].[tblPlaidStripeDataElements] tblPSDE with(nolock) where isnull(tblPSDE.[PlaidStripeDataElementsID],'') = isnull(@PlaidStripeDataElementsID,'')),'No')

	SET @Parameters = ' @PlaidStripeDataElementsID ' + cast(@PlaidStripeDataElementsID as nvarchar) + 
	                  ' @ApplyNowID ' + cast(@ApplyNowID as nvarchar) + 
	                  ' @Charged ' + cast(@Charged as nvarchar) + 
	                  ' @PlaidStripeID ' + cast(@PlaidStripeID as nvarchar) + 
	                  ' @PaymentAmount ' + cast(@PaymentAmount as nvarchar) + 
	                  ' @PaymentMethodTypeID ' + cast(@PaymentMethodTypeID as nvarchar)+
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblPlaidStripeDataElements]
					([ApplyNowID]
					,[Charged]
					,[PlaidStripeID]
					,[PaymentAmount]
					,[PaymentMethodTypeID])
				VALUES
					(@ApplyNowID				-- ApplyNowID
					,@Charged		-- Charged
					,@PlaidStripeID          -- PlaidStripeID
					,@PaymentAmount			-- PaymentAmount
					,@PaymentMethodTypeID)	-- PaymentMethodTypeID

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

				update [dbo].[tblPlaidStripeDataElements]
				set [ApplyNowID] = @ApplyNowID
					,[Charged] = @Charged
					,[PlaidStripeID] = @PlaidStripeID
					,[PaymentAmount] = @PaymentAmount
					,[PaymentMethodTypeID] = @PaymentMethodTypeID
				where [PlaidStripeDataElementsID] = @PlaidStripeDataElementsID;

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

	SET @PlaidStripeDataElementsID = isnull((SELECT [PlaidStripeDataElementsID]
											FROM [dbo].[tblPlaidStripeDataElements] with(nolock)
											where isnull([ApplyNowID],'') = isnull(@ApplyNowID,'')
											and isnull([Charged],'') = isnull(@Charged,'')
											and isnull([PlaidStripeID],'') = isnull(@PlaidStripeID,'')
											and isnull([PaymentAmount],'') = isnull(@PaymentAmount,'')
											and isnull([PaymentMethodTypeID],'') = isnull(@PaymentMethodTypeID,'')),0)

	SELECT @PlaidStripeDataElementsID AS [PlaidStripeDataElementsID]
	set @Output = '@PlaidStripeDataElementsID ' + cast(@PlaidStripeDataElementsID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

	EXEC [maint].[spSetLogStoredProcedureCalls]
	@Procedure = @Procedure,
	@Message = @Message,
	@Parameters = @Parameters,
	@Output = @Output,
	@StartSPCall = @StartSPCall

END