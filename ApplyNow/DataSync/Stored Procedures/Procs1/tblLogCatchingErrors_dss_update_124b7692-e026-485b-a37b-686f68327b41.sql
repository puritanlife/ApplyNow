﻿CREATE PROCEDURE [DataSync].[tblLogCatchingErrors_dss_update_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 NVarChar(max),
	@P_3 NVarChar(max),
	@P_4 NVarChar(max),
	@P_5 NVarChar(max),
	@P_6 NVarChar(max),
	@P_7 NVarChar(max),
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
WHERE [object_id] = 226099846 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 226099846 
 AND [owner_scope_local_id] = 3
SET @sync_row_count = 0; UPDATE [maint].[tblLogCatchingErrors] SET [ErrorNumber] = @P_2, [ErrorSeverity] = @P_3, [ErrorState] = @P_4, [ErrorProcedure] = @P_5, [ErrorMessage] = @P_6, [ErrorParameters] = @P_7, [CreatedDate] = @P_8, [LastModifiedDate] = @P_9 FROM [maint].[tblLogCatchingErrors] [base] LEFT JOIN [DataSync].[tblLogCatchingErrors_dss_tracking] [side] ON [base].[LogCatchingErrorsID] = [side].[LogCatchingErrorsID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[LogCatchingErrorsID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END