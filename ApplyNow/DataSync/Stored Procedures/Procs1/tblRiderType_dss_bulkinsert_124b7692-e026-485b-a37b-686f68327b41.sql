CREATE PROCEDURE [DataSync].[tblRiderType_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblRiderType_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([RiderTypeID] int, PRIMARY KEY ([RiderTypeID]));

SET IDENTITY_INSERT [dbo].[tblRiderType] ON;
-- update/insert into the base table
MERGE [dbo].[tblRiderType] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblRiderType_dss_tracking] t ON p.[RiderTypeID] = t.[RiderTypeID]) AS changes ON changes.[RiderTypeID] = base.[RiderTypeID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([RiderTypeID], [Type], [Descr], [CreatedDate], [LastModifiedDate]) VALUES (changes.[RiderTypeID], changes.[Type], changes.[Descr], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[RiderTypeID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblRiderType] OFF;
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
[DataSync].[tblRiderType_dss_tracking] side JOIN 
(SELECT p.[RiderTypeID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[RiderTypeID] = t.[RiderTypeID]) AS changes ON changes.[RiderTypeID] = side.[RiderTypeID]
SELECT [RiderTypeID] FROM @changeTable t WHERE NOT EXISTS (SELECT [RiderTypeID] from @changed i WHERE t.[RiderTypeID] = i.[RiderTypeID])
END