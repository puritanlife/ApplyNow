CREATE PROCEDURE [DataSync].[tblEmailNotification_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 NVarChar(60),
	@P_3 NVarChar(75),
	@P_4 NVarChar(75),
	@P_5 NVarChar(75),
	@P_6 NVarChar(60),
	@P_7 DateTime,
	@P_8 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblEmailNotification] WHERE [EmailNotificationID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblEmailNotification_dss_tracking] WHERE [EmailNotificationID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblEmailNotification] ON; INSERT INTO [dbo].[tblEmailNotification]([EmailNotificationID], [EmailAddress], [SG_MessageID], [SG_EventID], [EventStatus], [IP_Address], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblEmailNotification] OFF; END 
END