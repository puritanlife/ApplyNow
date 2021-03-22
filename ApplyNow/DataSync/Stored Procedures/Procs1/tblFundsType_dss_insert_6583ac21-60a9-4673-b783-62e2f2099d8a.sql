CREATE PROCEDURE [DataSync].[tblFundsType_dss_insert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 NVarChar(max),
	@P_3 NVarChar(max),
	@P_4 DateTime,
	@P_5 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblFundsType] WHERE [FundsTypeID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblFundsType_dss_tracking] WHERE [FundsTypeID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblFundsType] ON; INSERT INTO [dbo].[tblFundsType]([FundsTypeID], [Type], [Descr], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblFundsType] OFF; END 
END