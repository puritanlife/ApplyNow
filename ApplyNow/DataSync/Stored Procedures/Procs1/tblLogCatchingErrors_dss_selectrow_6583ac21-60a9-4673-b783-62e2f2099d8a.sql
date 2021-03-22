﻿CREATE PROCEDURE [DataSync].[tblLogCatchingErrors_dss_selectrow_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@sync_scope_local_id Int,
	@sync_scope_restore_count Int
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
 AND [owner_scope_local_id] = 1
SELECT (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[LogCatchingErrorsID]
ELSE [base].[LogCatchingErrorsID] END) 
as [LogCatchingErrorsID], 
[base].[ErrorNumber], [base].[ErrorSeverity], [base].[ErrorState], [base].[ErrorProcedure], [base].[ErrorMessage], [base].[ErrorParameters], [base].[CreatedDate], [base].[LastModifiedDate], (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[sync_row_is_tombstone]
ELSE 0
 END) 
 as sync_row_is_tombstone, (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  as sync_row_timestamp, case when ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[update_scope_local_id]
ELSE @marker_update_scope_local_id
 END)  is null or (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[update_scope_local_id]
ELSE @marker_update_scope_local_id
 END)  <> @sync_scope_local_id) then (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  else (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[scope_update_peer_timestamp]
ELSE @marker_scope_update_peer_timestamp
 END)  end as sync_update_peer_timestamp, case when ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[update_scope_local_id]
ELSE @marker_update_scope_local_id
 END)  is null or (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[update_scope_local_id]
ELSE @marker_update_scope_local_id
 END)  <> @sync_scope_local_id) then case when ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_key]
ELSE @marker_local_update_peer_key
 END)  > @sync_scope_restore_count) then @sync_scope_restore_count else (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_key]
ELSE @marker_local_update_peer_key
 END)  end else (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[scope_update_peer_key]
ELSE @marker_scope_update_peer_key
 END)  end as sync_update_peer_key, case when ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[create_scope_local_id]
ELSE @marker_create_scope_local_id
 END) 
 is null or (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[create_scope_local_id]
ELSE @marker_create_scope_local_id
 END) 
 <> @sync_scope_local_id) then (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[local_create_peer_timestamp]
ELSE @marker_local_create_peer_timestamp
 END) 
 else (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[scope_create_peer_timestamp]
ELSE @marker_scope_create_peer_timestamp
 END) 
 end as sync_create_peer_timestamp, case when ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[create_scope_local_id]
ELSE @marker_create_scope_local_id
 END) 
 is null or (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[create_scope_local_id]
ELSE @marker_create_scope_local_id
 END) 
 <> @sync_scope_local_id) then case when ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[local_create_peer_key]
ELSE @marker_local_create_peer_key
 END) 
 > @sync_scope_restore_count) then @sync_scope_restore_count else (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[local_create_peer_key]
ELSE @marker_local_create_peer_key
 END) 
 end else (CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL 
THEN [side].[scope_create_peer_key]
ELSE @marker_scope_create_peer_key
 END) 
 end as sync_create_peer_key FROM (SELECT * FROM [maint].[tblLogCatchingErrors] WHERE [LogCatchingErrorsID] = @P_1) [base] FULL OUTER JOIN (SELECT * FROM [DataSync].[tblLogCatchingErrors_dss_tracking] WHERE [LogCatchingErrorsID] = @P_1) [side] ON [base].[LogCatchingErrorsID] = [side].[LogCatchingErrorsID]
END