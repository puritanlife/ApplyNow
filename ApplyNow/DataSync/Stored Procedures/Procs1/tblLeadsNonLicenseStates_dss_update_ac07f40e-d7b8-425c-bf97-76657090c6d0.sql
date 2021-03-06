CREATE PROCEDURE [DataSync].[tblLeadsNonLicenseStates_dss_update_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 Int,
	@P_3 NVarChar(250),
	@P_4 Int,
	@P_5 Int,
	@P_6 Int,
	@P_7 NVarChar(100),
	@P_8 DateTime,
	@P_9 DateTime,
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
WHERE [object_id] = 690101499 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 690101499 
 AND [owner_scope_local_id] = 2
SET @sync_row_count = 0; UPDATE [dbo].[tblLeadsNonLicenseStates] SET [ProductPlanPeriodID] = @P_2, [UUID] = @P_3, [StateID] = @P_4, [Premium] = @P_5, [StateLicenseTypeID] = @P_6, [Email] = @P_7, [CreatedDate] = @P_8, [LastModifiedDate] = @P_9 FROM [dbo].[tblLeadsNonLicenseStates] [base] LEFT JOIN [DataSync].[tblLeadsNonLicenseStates_dss_tracking] [side] ON [base].[LeadsNonLicenseStatesID] = [side].[LeadsNonLicenseStatesID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[LeadsNonLicenseStatesID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END