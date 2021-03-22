CREATE PROCEDURE [DataSync].[tblGenderType_dss_bulkinsert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblGenderType_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([GenderTypeID] int, PRIMARY KEY ([GenderTypeID]));

SET IDENTITY_INSERT [dbo].[tblGenderType] ON;
-- update/insert into the base table
MERGE [dbo].[tblGenderType] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblGenderType_dss_tracking] t ON p.[GenderTypeID] = t.[GenderTypeID]) AS changes ON changes.[GenderTypeID] = base.[GenderTypeID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([GenderTypeID], [Type], [Descr], [CreatedDate], [LastModifiedDate]) VALUES (changes.[GenderTypeID], changes.[Type], changes.[Descr], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[GenderTypeID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblGenderType] OFF;
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
[DataSync].[tblGenderType_dss_tracking] side JOIN 
(SELECT p.[GenderTypeID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[GenderTypeID] = t.[GenderTypeID]) AS changes ON changes.[GenderTypeID] = side.[GenderTypeID]
SELECT [GenderTypeID] FROM @changeTable t WHERE NOT EXISTS (SELECT [GenderTypeID] from @changed i WHERE t.[GenderTypeID] = i.[GenderTypeID])
END