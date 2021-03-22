CREATE PROCEDURE [DataSync].[tblAdminUser_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblAdminUser_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([AdminUserId] int, PRIMARY KEY ([AdminUserId]));

SET IDENTITY_INSERT [dbo].[tblAdminUser] ON;
-- update/insert into the base table
MERGE [dbo].[tblAdminUser] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblAdminUser_dss_tracking] t ON p.[AdminUserId] = t.[AdminUserId]) AS changes ON changes.[AdminUserId] = base.[AdminUserId]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([AdminUserId], [Email], [Pass], [Attempt], [locked], [Last_Login], [PasswordChangeDate], [CreatedDate], [LastModifiedDate]) VALUES (changes.[AdminUserId], changes.[Email], changes.[Pass], changes.[Attempt], changes.[locked], changes.[Last_Login], changes.[PasswordChangeDate], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[AdminUserId] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblAdminUser] OFF;
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
[DataSync].[tblAdminUser_dss_tracking] side JOIN 
(SELECT p.[AdminUserId], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[AdminUserId] = t.[AdminUserId]) AS changes ON changes.[AdminUserId] = side.[AdminUserId]
SELECT [AdminUserId] FROM @changeTable t WHERE NOT EXISTS (SELECT [AdminUserId] from @changed i WHERE t.[AdminUserId] = i.[AdminUserId])
END