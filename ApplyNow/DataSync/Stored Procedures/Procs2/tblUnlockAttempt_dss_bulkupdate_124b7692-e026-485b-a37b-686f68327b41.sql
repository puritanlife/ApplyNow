CREATE PROCEDURE [DataSync].[tblUnlockAttempt_dss_bulkupdate_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblUnlockAttempt_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
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
WHERE [object_id] = 1458104235 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1458104235 
 AND [owner_scope_local_id] = 3
-- use a temp table to store the list of PKs that successfully got updated
declare @changed TABLE ([UnlockAttemptID] int, PRIMARY KEY ([UnlockAttemptID]));

SET IDENTITY_INSERT [dbo].[tblUnlockAttempt] ON;
-- update the base table
MERGE [dbo].[tblUnlockAttempt] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.update_scope_local_id, t.scope_update_peer_key, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblUnlockAttempt_dss_tracking] t ON p.[UnlockAttemptID] = t.[UnlockAttemptID]) as changes ON changes.[UnlockAttemptID] = base.[UnlockAttemptID]
WHEN MATCHED AND (changes.update_scope_local_id = @sync_scope_local_id AND changes.scope_update_peer_key = changes.sync_update_peer_key) OR changes.local_update_peer_timestamp <= @sync_min_timestamp-- No tracking record exists
OR (changes.update_scope_local_id IS NULL AND changes.scope_update_peer_key IS NULL AND changes.local_update_peer_timestamp IS NULL) 
 THEN
UPDATE SET [UserID] = changes.[UserID], [Email] = changes.[Email], [SuccessFlag] = changes.[SuccessFlag], [AttemptDate] = changes.[AttemptDate], [AttemptMessage] = changes.[AttemptMessage], [CreatedDate] = changes.[CreatedDate], [LastModifiedDate] = changes.[LastModifiedDate]
OUTPUT INSERTED.[UnlockAttemptID] into @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblUnlockAttempt] OFF;
UPDATE side SET
update_scope_local_id = @sync_scope_local_id, 
scope_update_peer_key = changes.sync_update_peer_key, 
scope_update_peer_timestamp = changes.sync_update_peer_timestamp,
local_update_peer_key = 0
FROM 
[DataSync].[tblUnlockAttempt_dss_tracking] side JOIN 
(SELECT p.[UnlockAttemptID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[UnlockAttemptID] = t.[UnlockAttemptID]) as changes ON changes.[UnlockAttemptID] = side.[UnlockAttemptID]
SELECT [UnlockAttemptID] FROM @changeTable t WHERE NOT EXISTS (SELECT [UnlockAttemptID] from @changed i WHERE t.[UnlockAttemptID] = i.[UnlockAttemptID])
END