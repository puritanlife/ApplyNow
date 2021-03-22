CREATE PROCEDURE [DataSync].[tblAddress_dss_insert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 NVarChar(max),
	@P_5 NVarChar(max),
	@P_6 NVarChar(max),
	@P_7 Int,
	@P_8 NVarChar(max),
	@P_9 DateTime,
	@P_10 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblAddress] WHERE [AddressID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblAddress_dss_tracking] WHERE [AddressID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblAddress] ON; INSERT INTO [dbo].[tblAddress]([AddressID], [PersonID], [AddressTypeID], [Address1], [Address2], [City], [StateID], [ZipCode], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblAddress] OFF; END 
END