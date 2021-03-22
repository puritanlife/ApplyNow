CREATE PROCEDURE [DataSync].[tblEmailType_dss_bulkinsert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblEmailType_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([EmailTypeID] int, PRIMARY KEY ([EmailTypeID]));

SET IDENTITY_INSERT [dbo].[tblEmailType] ON;
-- update/insert into the base table
MERGE [dbo].[tblEmailType] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblEmailType_dss_tracking] t ON p.[EmailTypeID] = t.[EmailTypeID]) AS changes ON changes.[EmailTypeID] = base.[EmailTypeID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([EmailTypeID], [Type], [Descr], [CreatedDate], [LastModifiedDate]) VALUES (changes.[EmailTypeID], changes.[Type], changes.[Descr], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[EmailTypeID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblEmailType] OFF;
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
[DataSync].[tblEmailType_dss_tracking] side JOIN 
(SELECT p.[EmailTypeID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[EmailTypeID] = t.[EmailTypeID]) AS changes ON changes.[EmailTypeID] = side.[EmailTypeID]
SELECT [EmailTypeID] FROM @changeTable t WHERE NOT EXISTS (SELECT [EmailTypeID] from @changed i WHERE t.[EmailTypeID] = i.[EmailTypeID])
END