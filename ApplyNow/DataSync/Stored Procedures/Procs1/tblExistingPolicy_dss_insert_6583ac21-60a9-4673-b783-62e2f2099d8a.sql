CREATE PROCEDURE [DataSync].[tblExistingPolicy_dss_insert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 Int,
	@P_3 NVarChar(255),
	@P_4 Date,
	@P_5 Int,
	@P_6 Bit,
	@P_7 Bit,
	@P_8 DateTime,
	@P_9 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblExistingPolicy] WHERE [ExistingPolicyID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblExistingPolicy_dss_tracking] WHERE [ExistingPolicyID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblExistingPolicy] ON; INSERT INTO [dbo].[tblExistingPolicy]([ExistingPolicyID], [ApplyNowID], [PolicyNumber], [IssueDate], [CarrierID], [ChangePolicies], [ExistingPolicies], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblExistingPolicy] OFF; END 
END