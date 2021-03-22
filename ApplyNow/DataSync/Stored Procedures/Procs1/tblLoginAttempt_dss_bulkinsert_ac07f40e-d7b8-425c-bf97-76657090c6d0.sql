CREATE PROCEDURE [DataSync].[tblLoginAttempt_dss_bulkinsert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblLoginAttempt_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([LoginAttemptID] int, PRIMARY KEY ([LoginAttemptID]));

SET IDENTITY_INSERT [dbo].[tblLoginAttempt] ON;
-- update/insert into the base table
MERGE [dbo].[tblLoginAttempt] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblLoginAttempt_dss_tracking] t ON p.[LoginAttemptID] = t.[LoginAttemptID]) AS changes ON changes.[LoginAttemptID] = base.[LoginAttemptID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([LoginAttemptID], [UserID], [Email], [SuccessFlag], [AttemptDate], [AttemptMessage], [CreatedDate], [LastModifiedDate]) VALUES (changes.[LoginAttemptID], changes.[UserID], changes.[Email], changes.[SuccessFlag], changes.[AttemptDate], changes.[AttemptMessage], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[LoginAttemptID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblLoginAttempt] OFF;
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
[DataSync].[tblLoginAttempt_dss_tracking] side JOIN 
(SELECT p.[LoginAttemptID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[LoginAttemptID] = t.[LoginAttemptID]) AS changes ON changes.[LoginAttemptID] = side.[LoginAttemptID]
SELECT [LoginAttemptID] FROM @changeTable t WHERE NOT EXISTS (SELECT [LoginAttemptID] from @changed i WHERE t.[LoginAttemptID] = i.[LoginAttemptID])
END