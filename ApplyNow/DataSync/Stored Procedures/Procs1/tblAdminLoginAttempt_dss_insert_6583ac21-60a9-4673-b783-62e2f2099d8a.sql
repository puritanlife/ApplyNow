CREATE PROCEDURE [DataSync].[tblAdminLoginAttempt_dss_insert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 Int,
	@P_3 NVarChar(75),
	@P_4 Int,
	@P_5 DateTime,
	@P_6 NVarChar(255),
	@P_7 DateTime,
	@P_8 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblAdminLoginAttempt] WHERE [AdminLoginAttemptID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblAdminLoginAttempt_dss_tracking] WHERE [AdminLoginAttemptID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblAdminLoginAttempt] ON; INSERT INTO [dbo].[tblAdminLoginAttempt]([AdminLoginAttemptID], [AdminUserID], [Email], [SuccessFlag], [AttemptDate], [AttemptMessage], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblAdminLoginAttempt] OFF; END 
END