CREATE PROCEDURE [DataSync].[tblEmailReset_dss_insert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 NVarChar(75),
	@P_3 NVarChar(75),
	@P_4 NVarChar(60),
	@P_5 DateTime,
	@P_6 Bit,
	@P_7 DateTime,
	@P_8 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblEmailReset] WHERE [EmailResetID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblEmailReset_dss_tracking] WHERE [EmailResetID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblEmailReset] ON; INSERT INTO [dbo].[tblEmailReset]([EmailResetID], [OldEmail], [NewEmail], [Token], [TimeStamp], [UsedToken], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblEmailReset] OFF; END 
END