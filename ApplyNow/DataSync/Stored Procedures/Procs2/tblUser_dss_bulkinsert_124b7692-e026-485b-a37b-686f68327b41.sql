CREATE PROCEDURE [DataSync].[tblUser_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblUser_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([UserId] int, PRIMARY KEY ([UserId]));

SET IDENTITY_INSERT [dbo].[tblUser] ON;
-- update/insert into the base table
MERGE [dbo].[tblUser] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblUser_dss_tracking] t ON p.[UserId] = t.[UserId]) AS changes ON changes.[UserId] = base.[UserId]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([UserId], [PersonID], [UserTypeID], [Email], [Pass], [Attempt], [locked], [Last_Login], [IsAdmin], [PasswordChangeDate], [Question1], [Answer1], [Question2], [Answer2], [Question3], [Answer3], [Question1ChangeDate], [Answer1ChangeDate], [Question2ChangeDate], [Answer2ChangeDate], [Question3ChangeDate], [Answer3ChangeDate], [CreatedDate], [LastModifiedDate]) VALUES (changes.[UserId], changes.[PersonID], changes.[UserTypeID], changes.[Email], changes.[Pass], changes.[Attempt], changes.[locked], changes.[Last_Login], changes.[IsAdmin], changes.[PasswordChangeDate], changes.[Question1], changes.[Answer1], changes.[Question2], changes.[Answer2], changes.[Question3], changes.[Answer3], changes.[Question1ChangeDate], changes.[Answer1ChangeDate], changes.[Question2ChangeDate], changes.[Answer2ChangeDate], changes.[Question3ChangeDate], changes.[Answer3ChangeDate], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[UserId] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblUser] OFF;
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
[DataSync].[tblUser_dss_tracking] side JOIN 
(SELECT p.[UserId], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[UserId] = t.[UserId]) AS changes ON changes.[UserId] = side.[UserId]
SELECT [UserId] FROM @changeTable t WHERE NOT EXISTS (SELECT [UserId] from @changed i WHERE t.[UserId] = i.[UserId])
END