CREATE PROCEDURE [DataSync].[tblStateLicenseType_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblStateLicenseType_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([StateLicenseTypeID] int, PRIMARY KEY ([StateLicenseTypeID]));

SET IDENTITY_INSERT [dbo].[tblStateLicenseType] ON;
-- update/insert into the base table
MERGE [dbo].[tblStateLicenseType] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblStateLicenseType_dss_tracking] t ON p.[StateLicenseTypeID] = t.[StateLicenseTypeID]) AS changes ON changes.[StateLicenseTypeID] = base.[StateLicenseTypeID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([StateLicenseTypeID], [Type], [Descr], [CreatedDate], [LastModifiedDate]) VALUES (changes.[StateLicenseTypeID], changes.[Type], changes.[Descr], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[StateLicenseTypeID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblStateLicenseType] OFF;
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
[DataSync].[tblStateLicenseType_dss_tracking] side JOIN 
(SELECT p.[StateLicenseTypeID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[StateLicenseTypeID] = t.[StateLicenseTypeID]) AS changes ON changes.[StateLicenseTypeID] = side.[StateLicenseTypeID]
SELECT [StateLicenseTypeID] FROM @changeTable t WHERE NOT EXISTS (SELECT [StateLicenseTypeID] from @changed i WHERE t.[StateLicenseTypeID] = i.[StateLicenseTypeID])
END