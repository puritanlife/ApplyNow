CREATE PROCEDURE [DataSync].[tblPersonPhone_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 NVarChar(max),
	@P_5 DateTime,
	@P_6 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblPersonPhone] WHERE [PersonPhoneID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblPersonPhone_dss_tracking] WHERE [PersonPhoneID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblPersonPhone] ON; INSERT INTO [dbo].[tblPersonPhone]([PersonPhoneID], [PersonID], [PhoneTypeID], [PhoneNumber], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblPersonPhone] OFF; END 
END