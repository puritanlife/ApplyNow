CREATE PROCEDURE [DataSync].[tblVerificationExistingIDAgainstComment_dss_insert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 Date,
	@P_5 DateTime,
	@P_6 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [maint].[tblVerificationExistingIDAgainstComment] WHERE [LogExistingIDAgainstCommentID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblVerificationExistingIDAgainstComment_dss_tracking] WHERE [LogExistingIDAgainstCommentID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [maint].[tblVerificationExistingIDAgainstComment] ON; INSERT INTO [maint].[tblVerificationExistingIDAgainstComment]([LogExistingIDAgainstCommentID], [LogVerificationCommentSQLID], [ExistingID], [AsOfDate], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [maint].[tblVerificationExistingIDAgainstComment] OFF; END 
END