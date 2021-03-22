CREATE PROCEDURE [DataSync].[tblAdminUser_dss_insert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 VarChar(75),
	@P_3 VarChar(60),
	@P_4 Int,
	@P_5 Bit,
	@P_6 DateTime,
	@P_7 DateTime,
	@P_8 DateTime,
	@P_9 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblAdminUser] WHERE [AdminUserId] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblAdminUser_dss_tracking] WHERE [AdminUserId] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblAdminUser] ON; INSERT INTO [dbo].[tblAdminUser]([AdminUserId], [Email], [Pass], [Attempt], [locked], [Last_Login], [PasswordChangeDate], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblAdminUser] OFF; END 
END