


CREATE PROCEDURE [dbo].[spSetEmailNotification]
(
    @EmailNotificationID [int] NULL,
	@EmailAddress nvarchar(60) NULL,
	@SG_MessageID nvarchar(75) NULL,
	@SG_EventID nvarchar(75) NULL,	
	@EventStatus nvarchar(75) NULL,
	@IP_Address nvarchar(60) NULL
)
AS
BEGIN
/*************************************************
  Author:      Poonam Kushwaha
  Create Date: 9/18/2020
  Description: Inserts a Person Email Notification Deatils.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetEmailNotification]' 
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

	if @EmailNotificationID is null 
		set @EmailNotificationID = isnull(@EmailNotificationID,-99);

	if @EmailAddress is null 
		set @EmailAddress = isnull(@EmailAddress,'');

	if @SG_MessageID is null 
		set @SG_MessageID = isnull(@SG_MessageID,'');

	if @SG_EventID is null 
		set @SG_EventID = isnull(@SG_EventID,'');

	if @EventStatus is null 
		set @EventStatus = isnull(@EventStatus,'');

	if @IP_Address is null 
		set @IP_Address = isnull(@IP_Address,'');
				
	if @EmailNotificationID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblEmailNotification] tblEN with(nolock) where isnull(tblEN.[EmailNotificationID],'') = isnull(@EmailNotificationID,'')),'No')

	SET @Parameters = ' @EmailNotificationID ' + cast(@EmailNotificationID as nvarchar) + 
	                  ' @EmailAddress ' + cast(@EmailAddress as nvarchar) + 
					  ' @SG_MessageID ' + cast(@SG_MessageID as nvarchar) +
					  ' @SG_EventID ' + cast(@SG_EventID as nvarchar) +
					  ' @EventStatus ' + cast(@EventStatus as nvarchar) +
					  ' @IP_Address ' + cast(@IP_Address as nvarchar) +
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblEmailNotification]
						   ([EmailAddress]
						   ,[SG_MessageID]
						   ,[SG_EventID]
						   ,[EventStatus]
						   ,[IP_Address])
					 VALUES
						   (@EmailAddress		-- PersonID
						   ,@SG_MessageID	-- EmailTypeID
						   ,@SG_EventID     --SendGrid EventID
						   ,@EventStatus          --Event
						   ,@IP_Address);	--IP Address

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

				update [dbo].[tblEmailNotification]
				set [EmailAddress] = @EmailAddress
				 , [SG_MessageID] = @SG_MessageID
				 , [SG_EventID] = @SG_EventID
				 , [EventStatus] = @EventStatus
				 , [IP_Address] = @IP_Address
				where [EmailAddress] = @EmailAddress;

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

	--set @EmailNotificationID = (select tblEN.[EmailNotificationID] from [dbo].[tblEmailNotification] tblEN with(nolock) where isnull(EmailID,'') = isnull(@EmailAddress,'') and isnull(SD_MessageID,'') = isnull(@SG_MessageID,''))
	set @EmailNotificationID = (select tblEN.[EmailNotificationID] from [dbo].[tblEmailNotification] tblEN with(nolock) where isnull(EmailNotificationID,'') = isnull(@@IDENTITY,''))
	
	select @EmailNotificationID AS 'EmailNotificationID'
	SET @Output = '@EmailNotificationID '+cast(@EmailNotificationID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END