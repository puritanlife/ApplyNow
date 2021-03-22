



CREATE PROCEDURE [dbo].[spGetEmailNotification]
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
  Description: Returns all data within the Email Notification table. 
**************************************************/
		
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetEmailNotification]' 
	DECLARE @Error nvarchar(max) = null 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 
	DECLARE @SP_RowCount int = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = '@EmailNotificationID ' + cast(@EmailNotificationID as nvarchar) + ' @EmailAddress ' + cast(@EmailAddress as nvarchar) + ' @SG_MessageID ' + cast(@SG_MessageID as nvarchar) + ' @SG_EventID ' + cast(@SG_EventID as nvarchar) + ' @EventStatus ' + cast(@EventStatus as nvarchar) + ' @IP_Address ' + cast(@IP_Address as nvarchar)

	SELECT 
	  tblEN.[EmailNotificationID] as [EmailNotificationID]
	, tblEN.[EmailAddress] as [EmailAddress]
	, tblEN.[SG_MessageID] as [SG_MessageID]
	, tblEN.[SG_EventID] as [SG_EventID]
	, tblEN.[EventStatus] as [EventStatus]
	, tblEN.[IP_Address] as [IP_Address]
	FROM [dbo].[tblEmailNotification] tblEN with(nolock) 
	where isnull(tblEN.[EmailNotificationID],'') = isnull(@EmailNotificationID,tblEN.[EmailNotificationID])
	and isnull(tblEN.[EmailAddress],'') = isnull(@EmailAddress,tblEN.[EmailAddress])
	and isnull(tblEN.[SG_MessageID],'') = isnull(@SG_MessageID,tblEN.[SG_MessageID])
	and isnull(tblEN.[SG_EventID],'') = isnull(@SG_EventID,tblEN.[SG_EventID])
	and isnull(tblEN.[EventStatus],'') = isnull(@EventStatus,tblEN.[EventStatus])
	and isnull(tblEN.[IP_Address],'') = isnull(@IP_Address,tblEN.[IP_Address])
	SET @SP_RowCount = @@ROWCOUNT;

	SET @Message = @Message + 'Select only, not inserts or updates. '
	SET @Output = @Output + 'Record Count ' + cast(@SP_RowCount as varchar)

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END