CREATE PROCEDURE [DataSync].[tblPasswordReset_dss_insert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 Int,
	@P_3 DateTime,
	@P_4 DateTime,
	@P_5 Bit,
	@P_6 DateTime,
	@P_7 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblPasswordReset] WHERE [PasswordResetId] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblPasswordReset_dss_tracking] WHERE [PasswordResetId] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblPasswordReset] ON; INSERT INTO [dbo].[tblPasswordReset]([PasswordResetId], [UserId], [Request_Date], [PasswordUsedDate], [PasswordUsed], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblPasswordReset] OFF; END 
END