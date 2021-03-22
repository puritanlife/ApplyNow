﻿CREATE PROCEDURE [DataSync].[tblAdminTempPass_dss_insert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 Int,
	@P_3 VarChar(60),
	@P_4 Bit,
	@P_5 DateTime,
	@P_6 DateTime,
	@P_7 DateTime,
	@P_8 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblAdminTempPass] WHERE [AdminTempPassID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblAdminTempPass_dss_tracking] WHERE [AdminTempPassID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblAdminTempPass] ON; INSERT INTO [dbo].[tblAdminTempPass]([AdminTempPassID], [AdminUserID], [Pass], [PasswordUsed], [ExpirationDate], [PasswordUsedDate], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblAdminTempPass] OFF; END 
END