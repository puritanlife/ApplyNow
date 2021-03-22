CREATE PROCEDURE [DataSync].[tblTransposeApplyNowApplication_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 Int,
	@P_5 Int,
	@P_6 Int,
	@P_7 Int,
	@P_8 Int,
	@P_9 Int,
	@P_10 Int,
	@P_11 Int,
	@P_12 Int,
	@P_13 Int,
	@P_14 Int,
	@P_15 DateTime,
	@P_16 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblTransposeApplyNowApplication] WHERE [TransposeApplyNowApplicationID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblTransposeApplyNowApplication_dss_tracking] WHERE [TransposeApplyNowApplicationID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblTransposeApplyNowApplication] ON; INSERT INTO [dbo].[tblTransposeApplyNowApplication]([TransposeApplyNowApplicationID], [ApplicationID], [ApplyNowIDOwner], [ApplyNowIDJointOwner], [ApplyNowIDAnnuitant], [ApplyNowIDJointAnnuitant], [ApplyNowIDBeneficiary1], [ApplyNowIDBeneficiary2], [ApplyNowIDBeneficiary3], [ApplyNowIDBeneficiary4], [ApplyNowIDBeneficiary5], [ApplyNowIDReplacementCompany], [ApplyNowIDUnknown], [ApplyNowIDAgent], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblTransposeApplyNowApplication] OFF; END 
END