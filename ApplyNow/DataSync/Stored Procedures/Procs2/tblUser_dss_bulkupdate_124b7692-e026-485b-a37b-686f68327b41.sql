CREATE PROCEDURE [DataSync].[tblUser_dss_bulkupdate_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblUser_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
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
WHERE [object_id] = 1490104349 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1490104349 
 AND [owner_scope_local_id] = 3
-- use a temp table to store the list of PKs that successfully got updated
declare @changed TABLE ([UserId] int, PRIMARY KEY ([UserId]));

SET IDENTITY_INSERT [dbo].[tblUser] ON;
-- update the base table
MERGE [dbo].[tblUser] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.update_scope_local_id, t.scope_update_peer_key, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblUser_dss_tracking] t ON p.[UserId] = t.[UserId]) as changes ON changes.[UserId] = base.[UserId]
WHEN MATCHED AND (changes.update_scope_local_id = @sync_scope_local_id AND changes.scope_update_peer_key = changes.sync_update_peer_key) OR changes.local_update_peer_timestamp <= @sync_min_timestamp-- No tracking record exists
OR (changes.update_scope_local_id IS NULL AND changes.scope_update_peer_key IS NULL AND changes.local_update_peer_timestamp IS NULL) 
 THEN
UPDATE SET [PersonID] = changes.[PersonID], [UserTypeID] = changes.[UserTypeID], [Email] = changes.[Email], [Pass] = changes.[Pass], [Attempt] = changes.[Attempt], [locked] = changes.[locked], [Last_Login] = changes.[Last_Login], [IsAdmin] = changes.[IsAdmin], [PasswordChangeDate] = changes.[PasswordChangeDate], [Question1] = changes.[Question1], [Answer1] = changes.[Answer1], [Question2] = changes.[Question2], [Answer2] = changes.[Answer2], [Question3] = changes.[Question3], [Answer3] = changes.[Answer3], [Question1ChangeDate] = changes.[Question1ChangeDate], [Answer1ChangeDate] = changes.[Answer1ChangeDate], [Question2ChangeDate] = changes.[Question2ChangeDate], [Answer2ChangeDate] = changes.[Answer2ChangeDate], [Question3ChangeDate] = changes.[Question3ChangeDate], [Answer3ChangeDate] = changes.[Answer3ChangeDate], [CreatedDate] = changes.[CreatedDate], [LastModifiedDate] = changes.[LastModifiedDate]
OUTPUT INSERTED.[UserId] into @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblUser] OFF;
UPDATE side SET
update_scope_local_id = @sync_scope_local_id, 
scope_update_peer_key = changes.sync_update_peer_key, 
scope_update_peer_timestamp = changes.sync_update_peer_timestamp,
local_update_peer_key = 0
FROM 
[DataSync].[tblUser_dss_tracking] side JOIN 
(SELECT p.[UserId], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[UserId] = t.[UserId]) as changes ON changes.[UserId] = side.[UserId]
SELECT [UserId] FROM @changeTable t WHERE NOT EXISTS (SELECT [UserId] from @changed i WHERE t.[UserId] = i.[UserId])
END