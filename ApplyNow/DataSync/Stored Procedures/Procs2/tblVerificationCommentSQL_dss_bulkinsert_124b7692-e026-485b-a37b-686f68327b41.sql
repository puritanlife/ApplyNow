CREATE PROCEDURE [DataSync].[tblVerificationCommentSQL_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblVerificationCommentSQL_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([LogVerificationCommentSQLID] int, PRIMARY KEY ([LogVerificationCommentSQLID]));

SET IDENTITY_INSERT [maint].[tblVerificationCommentSQL] ON;
-- update/insert into the base table
MERGE [maint].[tblVerificationCommentSQL] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblVerificationCommentSQL_dss_tracking] t ON p.[LogVerificationCommentSQLID] = t.[LogVerificationCommentSQLID]) AS changes ON changes.[LogVerificationCommentSQLID] = base.[LogVerificationCommentSQLID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([LogVerificationCommentSQLID], [Comment], [SQL], [CreatedDate], [LastModifiedDate], [StatusTypeID]) VALUES (changes.[LogVerificationCommentSQLID], changes.[Comment], changes.[SQL], changes.[CreatedDate], changes.[LastModifiedDate], changes.[StatusTypeID])
OUTPUT INSERTED.[LogVerificationCommentSQLID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [maint].[tblVerificationCommentSQL] OFF;
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
[DataSync].[tblVerificationCommentSQL_dss_tracking] side JOIN 
(SELECT p.[LogVerificationCommentSQLID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[LogVerificationCommentSQLID] = t.[LogVerificationCommentSQLID]) AS changes ON changes.[LogVerificationCommentSQLID] = side.[LogVerificationCommentSQLID]
SELECT [LogVerificationCommentSQLID] FROM @changeTable t WHERE NOT EXISTS (SELECT [LogVerificationCommentSQLID] from @changed i WHERE t.[LogVerificationCommentSQLID] = i.[LogVerificationCommentSQLID])
END