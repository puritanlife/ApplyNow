﻿CREATE PROCEDURE [DataSync].[tblAdminTempPass_dss_bulkinsert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblAdminTempPass_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([AdminTempPassID] int, PRIMARY KEY ([AdminTempPassID]));

SET IDENTITY_INSERT [dbo].[tblAdminTempPass] ON;
-- update/insert into the base table
MERGE [dbo].[tblAdminTempPass] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblAdminTempPass_dss_tracking] t ON p.[AdminTempPassID] = t.[AdminTempPassID]) AS changes ON changes.[AdminTempPassID] = base.[AdminTempPassID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([AdminTempPassID], [AdminUserID], [Pass], [PasswordUsed], [ExpirationDate], [PasswordUsedDate], [CreatedDate], [LastModifiedDate]) VALUES (changes.[AdminTempPassID], changes.[AdminUserID], changes.[Pass], changes.[PasswordUsed], changes.[ExpirationDate], changes.[PasswordUsedDate], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[AdminTempPassID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblAdminTempPass] OFF;
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
[DataSync].[tblAdminTempPass_dss_tracking] side JOIN 
(SELECT p.[AdminTempPassID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[AdminTempPassID] = t.[AdminTempPassID]) AS changes ON changes.[AdminTempPassID] = side.[AdminTempPassID]
SELECT [AdminTempPassID] FROM @changeTable t WHERE NOT EXISTS (SELECT [AdminTempPassID] from @changed i WHERE t.[AdminTempPassID] = i.[AdminTempPassID])
END