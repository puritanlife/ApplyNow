CREATE PROCEDURE [DataSync].[tblTransposeApplyNowApplication_dss_update_124b7692-e026-485b-a37b-686f68327b41]
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
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 2029966308 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 2029966308 
 AND [owner_scope_local_id] = 3
SET @sync_row_count = 0; UPDATE [dbo].[tblTransposeApplyNowApplication] SET [ApplicationID] = @P_2, [ApplyNowIDOwner] = @P_3, [ApplyNowIDJointOwner] = @P_4, [ApplyNowIDAnnuitant] = @P_5, [ApplyNowIDJointAnnuitant] = @P_6, [ApplyNowIDBeneficiary1] = @P_7, [ApplyNowIDBeneficiary2] = @P_8, [ApplyNowIDBeneficiary3] = @P_9, [ApplyNowIDBeneficiary4] = @P_10, [ApplyNowIDBeneficiary5] = @P_11, [ApplyNowIDReplacementCompany] = @P_12, [ApplyNowIDUnknown] = @P_13, [ApplyNowIDAgent] = @P_14, [CreatedDate] = @P_15, [LastModifiedDate] = @P_16 FROM [dbo].[tblTransposeApplyNowApplication] [base] LEFT JOIN [DataSync].[tblTransposeApplyNowApplication_dss_tracking] [side] ON [base].[TransposeApplyNowApplicationID] = [side].[TransposeApplyNowApplicationID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[TransposeApplyNowApplicationID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END