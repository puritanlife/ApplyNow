﻿CREATE PROCEDURE [DataSync].[tblStatusType_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblStatusType_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([StatusTypeID] int, PRIMARY KEY ([StatusTypeID]));

SET IDENTITY_INSERT [dbo].[tblStatusType] ON;
-- update/insert into the base table
MERGE [dbo].[tblStatusType] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblStatusType_dss_tracking] t ON p.[StatusTypeID] = t.[StatusTypeID]) AS changes ON changes.[StatusTypeID] = base.[StatusTypeID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([StatusTypeID], [Type], [Descr], [CreatedDate], [LastModifiedDate]) VALUES (changes.[StatusTypeID], changes.[Type], changes.[Descr], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[StatusTypeID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblStatusType] OFF;
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
[DataSync].[tblStatusType_dss_tracking] side JOIN 
(SELECT p.[StatusTypeID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[StatusTypeID] = t.[StatusTypeID]) AS changes ON changes.[StatusTypeID] = side.[StatusTypeID]
SELECT [StatusTypeID] FROM @changeTable t WHERE NOT EXISTS (SELECT [StatusTypeID] from @changed i WHERE t.[StatusTypeID] = i.[StatusTypeID])
END