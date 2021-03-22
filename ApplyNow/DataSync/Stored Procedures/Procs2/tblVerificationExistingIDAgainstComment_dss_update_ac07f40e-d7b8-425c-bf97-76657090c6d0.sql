CREATE PROCEDURE [DataSync].[tblVerificationExistingIDAgainstComment_dss_update_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 Date,
	@P_5 DateTime,
	@P_6 DateTime,
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
WHERE [object_id] = 699149536 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 699149536 
 AND [owner_scope_local_id] = 2
SET @sync_row_count = 0; UPDATE [maint].[tblVerificationExistingIDAgainstComment] SET [LogVerificationCommentSQLID] = @P_2, [ExistingID] = @P_3, [AsOfDate] = @P_4, [CreatedDate] = @P_5, [LastModifiedDate] = @P_6 FROM [maint].[tblVerificationExistingIDAgainstComment] [base] LEFT JOIN [DataSync].[tblVerificationExistingIDAgainstComment_dss_tracking] [side] ON [base].[LogExistingIDAgainstCommentID] = [side].[LogExistingIDAgainstCommentID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[LogExistingIDAgainstCommentID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END