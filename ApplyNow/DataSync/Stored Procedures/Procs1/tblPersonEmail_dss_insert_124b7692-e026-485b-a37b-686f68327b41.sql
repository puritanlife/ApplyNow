CREATE PROCEDURE [DataSync].[tblPersonEmail_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 NVarChar(max),
	@P_5 DateTime,
	@P_6 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblPersonEmail] WHERE [PersonEmailID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblPersonEmail_dss_tracking] WHERE [PersonEmailID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblPersonEmail] ON; INSERT INTO [dbo].[tblPersonEmail]([PersonEmailID], [PersonID], [EmailTypeID], [EmailAddress], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblPersonEmail] OFF; END 
END