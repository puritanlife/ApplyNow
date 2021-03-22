CREATE PROCEDURE [DataSync].[tblVerificationExistingIDAgainstComment_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblVerificationExistingIDAgainstComment_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([LogExistingIDAgainstCommentID] int, PRIMARY KEY ([LogExistingIDAgainstCommentID]));

SET IDENTITY_INSERT [maint].[tblVerificationExistingIDAgainstComment] ON;
-- update/insert into the base table
MERGE [maint].[tblVerificationExistingIDAgainstComment] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblVerificationExistingIDAgainstComment_dss_tracking] t ON p.[LogExistingIDAgainstCommentID] = t.[LogExistingIDAgainstCommentID]) AS changes ON changes.[LogExistingIDAgainstCommentID] = base.[LogExistingIDAgainstCommentID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([LogExistingIDAgainstCommentID], [LogVerificationCommentSQLID], [ExistingID], [AsOfDate], [CreatedDate], [LastModifiedDate]) VALUES (changes.[LogExistingIDAgainstCommentID], changes.[LogVerificationCommentSQLID], changes.[ExistingID], changes.[AsOfDate], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[LogExistingIDAgainstCommentID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [maint].[tblVerificationExistingIDAgainstComment] OFF;
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
[DataSync].[tblVerificationExistingIDAgainstComment_dss_tracking] side JOIN 
(SELECT p.[LogExistingIDAgainstCommentID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[LogExistingIDAgainstCommentID] = t.[LogExistingIDAgainstCommentID]) AS changes ON changes.[LogExistingIDAgainstCommentID] = side.[LogExistingIDAgainstCommentID]
SELECT [LogExistingIDAgainstCommentID] FROM @changeTable t WHERE NOT EXISTS (SELECT [LogExistingIDAgainstCommentID] from @changed i WHERE t.[LogExistingIDAgainstCommentID] = i.[LogExistingIDAgainstCommentID])
END