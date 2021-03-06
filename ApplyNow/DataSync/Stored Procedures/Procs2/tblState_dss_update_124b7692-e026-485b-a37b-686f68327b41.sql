CREATE PROCEDURE [DataSync].[tblState_dss_update_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 NVarChar(2),
	@P_3 NVarChar(50),
	@P_4 DateTime,
	@P_5 DateTime,
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
WHERE [object_id] = 1330103779 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1330103779 
 AND [owner_scope_local_id] = 3
SET @sync_row_count = 0; UPDATE [dbo].[tblState] SET [StateShort] = @P_2, [StateLong] = @P_3, [CreatedDate] = @P_4, [LastModifiedDate] = @P_5 FROM [dbo].[tblState] [base] LEFT JOIN [DataSync].[tblState_dss_tracking] [side] ON [base].[StateID] = [side].[StateID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[StateID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END