CREATE PROCEDURE [DataSync].[tblPersonPhone_dss_bulkinsert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblPersonPhone_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([PersonPhoneID] int, PRIMARY KEY ([PersonPhoneID]));

SET IDENTITY_INSERT [dbo].[tblPersonPhone] ON;
-- update/insert into the base table
MERGE [dbo].[tblPersonPhone] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblPersonPhone_dss_tracking] t ON p.[PersonPhoneID] = t.[PersonPhoneID]) AS changes ON changes.[PersonPhoneID] = base.[PersonPhoneID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([PersonPhoneID], [PersonID], [PhoneTypeID], [PhoneNumber], [CreatedDate], [LastModifiedDate]) VALUES (changes.[PersonPhoneID], changes.[PersonID], changes.[PhoneTypeID], changes.[PhoneNumber], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[PersonPhoneID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblPersonPhone] OFF;
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
[DataSync].[tblPersonPhone_dss_tracking] side JOIN 
(SELECT p.[PersonPhoneID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[PersonPhoneID] = t.[PersonPhoneID]) AS changes ON changes.[PersonPhoneID] = side.[PersonPhoneID]
SELECT [PersonPhoneID] FROM @changeTable t WHERE NOT EXISTS (SELECT [PersonPhoneID] from @changed i WHERE t.[PersonPhoneID] = i.[PersonPhoneID])
END