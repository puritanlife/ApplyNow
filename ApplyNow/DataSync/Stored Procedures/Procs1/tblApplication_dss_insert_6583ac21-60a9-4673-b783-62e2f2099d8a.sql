CREATE PROCEDURE [DataSync].[tblApplication_dss_insert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 Int,
	@P_3 NVarChar(250),
	@P_4 Int,
	@P_5 Float,
	@P_6 Bit,
	@P_7 Int,
	@P_8 NVarChar(100),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Int,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblApplication] WHERE [ApplicationID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblApplication_dss_tracking] WHERE [ApplicationID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblApplication] ON; INSERT INTO [dbo].[tblApplication]([ApplicationID], [ProductPlanPeriodID], [UUID], [StateID], [Premium], [ForCompany], [StatusTypeID], [CanvasPolicyNumber], [CreatedDate], [LastModifiedDate], [StateLicenseTypeID]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblApplication] OFF; END 
END