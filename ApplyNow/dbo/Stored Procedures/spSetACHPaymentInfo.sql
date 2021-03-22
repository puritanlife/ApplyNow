


CREATE PROCEDURE [dbo].[spSetACHPaymentInfo]
(
    @ACHPaymentInfoID [int] = null ,
	@AppID nvarchar(200) null ,
	@Command nvarchar(200) null ,
   	@Amount [nvarchar](100) NULL,
	@CustomerIPAddress [nvarchar](100) NULL,
	@Merchant_ReferenceID [nvarchar](100) NULL,
	@Billing_CustomerName [nvarchar](100) NULL,
	@AccountToken [nvarchar](100) NULL
	
)
AS
BEGIN
/*************************************************
  Author:      Poonam Kushwaha
  Create Date: 1/11/2021
  Description: Inserts a ACH Payment Info.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetACHPaymentInfo]' 
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

	if @Command is null 
		set @Command = 0

	if @AppID is null 
		set @AppID = 0

	if @Amount is null 
		set @Amount = 0

	if @CustomerIPAddress is null 
		set @CustomerIPAddress = 0
	
	if @Merchant_ReferenceID is null 
		set @Merchant_ReferenceID = 0
		
	if @Billing_CustomerName is null 
		set @Billing_CustomerName = 0

	if @AccountToken is null 
		set @AccountToken = 0

    set @Record_Exists = isnull((select 'Yes' from [dbo].[tblACHPaymentInfo] tblACHP with(nolock) where isnull(tblACHP.[AppID],'') = isnull(@AppID,'')),'No')

	SET @Parameters = ' @Command ' + cast(@Command as nvarchar) + 
					  ' @AppID ' + cast(@AppID as nvarchar) +
	                  ' @Amount ' + cast(@Amount as nvarchar) + 
	                  ' @CustomerIPAddress ' + cast(@CustomerIPAddress as nvarchar) + 
	                  ' @Merchant_ReferenceID ' + cast(@Merchant_ReferenceID as nvarchar) + 
	                  ' @Billing_CustomerName ' + cast(@Billing_CustomerName as nvarchar) + 
	                  ' @AccountToken ' + cast(@AccountToken as nvarchar)+
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblACHPaymentInfo]
					([Command]
					,[AppID]
					,[Amount]
					,[CustomerIPAddress]
					,[Merchant_ReferenceID]
					,[Billing_CustomerName]
					,[AccountToken])
				VALUES
					(@Command				-- Command
					,@AppID					-- AppID
					,@Amount				-- Amount
					,@CustomerIPAddress		-- CustomerIPAddress
					,@Merchant_ReferenceID  --
					,@Billing_CustomerName
					,@AccountToken)	-- PaymentMethodTypeID

						SET @ACHPaymentInfoID = isnull((SELECT [ACHPaymentInfoID]
											FROM [dbo].[tblACHPaymentInfo] with(nolock)
											where isnull([Command],'') = isnull(@Command,'')
											and isnull([AppID],'') = isnull(@AppID,'')
											and isnull([Amount],'') = isnull(@Amount,'')
											and isnull([CustomerIPAddress],'') = isnull(@CustomerIPAddress,'')
											and isnull([AccountToken],'') = isnull(@AccountToken,'')),0)
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
				set  [Command] = @Command
					,[Amount] = @Amount
					,[CustomerIPAddress] = @CustomerIPAddress
					,[Merchant_ReferenceID] = @Merchant_ReferenceID
					,[Billing_CustomerName] = @Billing_CustomerName
					,[AccountToken] = @AccountToken
					,[LastModifiedDate] = getdate()
				where [AppID] = @AppID;

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

		SET @ACHPaymentInfoID = isnull((SELECT [ACHPaymentInfoID]
											FROM [dbo].[tblACHPaymentInfo] with(nolock)
											where isnull([AppID],'') = isnull(@AppID,'')),0)

	
	SELECT @ACHPaymentInfoID AS [ACHPaymentInfoID]
	set @Output = '@ACHPaymentInfoID ' + cast(@ACHPaymentInfoID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

	EXEC [maint].[spSetLogStoredProcedureCalls]
	@Procedure = @Procedure,
	@Message = @Message,
	@Parameters = @Parameters,
	@Output = @Output,
	@StartSPCall = @StartSPCall

END