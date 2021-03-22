CREATE PROCEDURE [DataSync].[tblLeadsNonLicenseStates_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 Int,
	@P_3 NVarChar(250),
	@P_4 Int,
	@P_5 Int,
	@P_6 Int,
	@P_7 NVarChar(100),
	@P_8 DateTime,
	@P_9 DateTime,
	@P_10 NVarChar(20),
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblLeadsNonLicenseStates] WHERE [LeadsNonLicenseStatesID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblLeadsNonLicenseStates_dss_tracking] WHERE [LeadsNonLicenseStatesID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblLeadsNonLicenseStates] ON; INSERT INTO [dbo].[tblLeadsNonLicenseStates]([LeadsNonLicenseStatesID], [ProductPlanPeriodID], [UUID], [StateID], [Premium], [StateLicenseTypeID], [Email], [CreatedDate], [LastModifiedDate], [LeadStatus]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblLeadsNonLicenseStates] OFF; END 
END