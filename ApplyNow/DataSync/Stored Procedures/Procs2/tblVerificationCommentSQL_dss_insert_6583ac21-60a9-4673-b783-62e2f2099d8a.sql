CREATE PROCEDURE [DataSync].[tblVerificationCommentSQL_dss_insert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 NVarChar(max),
	@P_3 NVarChar(max),
	@P_4 DateTime,
	@P_5 DateTime,
	@P_6 Int,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [maint].[tblVerificationCommentSQL] WHERE [LogVerificationCommentSQLID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblVerificationCommentSQL_dss_tracking] WHERE [LogVerificationCommentSQLID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [maint].[tblVerificationCommentSQL] ON; INSERT INTO [maint].[tblVerificationCommentSQL]([LogVerificationCommentSQLID], [Comment], [SQL], [CreatedDate], [LastModifiedDate], [StatusTypeID]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [maint].[tblVerificationCommentSQL] OFF; END 
END