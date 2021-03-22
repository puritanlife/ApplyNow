CREATE PROCEDURE [DataSync].[tblLogStoredProcedureCalls_dss_update_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 NVarChar(max),
	@P_3 NVarChar(max),
	@P_4 NVarChar(max),
	@P_5 NVarChar(max),
	@P_6 DateTime,
	@P_7 DateTime,
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
WHERE [object_id] = 130099504 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 130099504 
 AND [owner_scope_local_id] = 1
SET @sync_row_count = 0; UPDATE [maint].[tblLogStoredProcedureCalls] SET [Procedure] = @P_2, [Message] = @P_3, [Parameters] = @P_4, [Output] = @P_5, [StartSPCall] = @P_6, [EndSPCall] = @P_7, [CreatedDate] = @P_8, [LastModifiedDate] = @P_9 FROM [maint].[tblLogStoredProcedureCalls] [base] LEFT JOIN [DataSync].[tblLogStoredProcedureCalls_dss_tracking] [side] ON [base].[LogStoredProcedureCallsID] = [side].[LogStoredProcedureCallsID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[LogStoredProcedureCallsID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END