CREATE PROCEDURE [DataSync].[tblEmailReset_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblEmailReset_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([EmailResetID] int, PRIMARY KEY ([EmailResetID]));

SET IDENTITY_INSERT [dbo].[tblEmailReset] ON;
-- update/insert into the base table
MERGE [dbo].[tblEmailReset] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblEmailReset_dss_tracking] t ON p.[EmailResetID] = t.[EmailResetID]) AS changes ON changes.[EmailResetID] = base.[EmailResetID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([EmailResetID], [OldEmail], [NewEmail], [Token], [TimeStamp], [UsedToken], [CreatedDate], [LastModifiedDate]) VALUES (changes.[EmailResetID], changes.[OldEmail], changes.[NewEmail], changes.[Token], changes.[TimeStamp], changes.[UsedToken], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[EmailResetID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblEmailReset] OFF;
UPDATE side SET
update_scope_local_id = @sync_scope_local_id, 
scope_update_peer_key = changes.sync_update_peer_key, 
scope_update_peer_timestamp = changes.sync_update_peer_timestamp,
local_update_peer_key = 0,
create_scope_local_id = @sync_scope_local_id,
scope_create_peer_key = changes.sync_create_peer_key,
scope_create_peer_timestamp = changes.sync_create_peer_timestamp,
local_create_peer_key = 0
FROM 
[DataSync].[tblEmailReset_dss_tracking] side JOIN 
(SELECT p.[EmailResetID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[EmailResetID] = t.[EmailResetID]) AS changes ON changes.[EmailResetID] = side.[EmailResetID]
SELECT [EmailResetID] FROM @changeTable t WHERE NOT EXISTS (SELECT [EmailResetID] from @changed i WHERE t.[EmailResetID] = i.[EmailResetID])
END