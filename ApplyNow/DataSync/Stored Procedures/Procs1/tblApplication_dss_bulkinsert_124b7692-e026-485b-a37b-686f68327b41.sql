CREATE PROCEDURE [DataSync].[tblApplication_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblApplication_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([ApplicationID] int, PRIMARY KEY ([ApplicationID]));

SET IDENTITY_INSERT [dbo].[tblApplication] ON;
-- update/insert into the base table
MERGE [dbo].[tblApplication] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblApplication_dss_tracking] t ON p.[ApplicationID] = t.[ApplicationID]) AS changes ON changes.[ApplicationID] = base.[ApplicationID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([ApplicationID], [ProductPlanPeriodID], [UUID], [StateID], [Premium], [ForCompany], [StatusTypeID], [CanvasPolicyNumber], [CreatedDate], [LastModifiedDate], [StateLicenseTypeID], [AppValidation]) VALUES (changes.[ApplicationID], changes.[ProductPlanPeriodID], changes.[UUID], changes.[StateID], changes.[Premium], changes.[ForCompany], changes.[StatusTypeID], changes.[CanvasPolicyNumber], changes.[CreatedDate], changes.[LastModifiedDate], changes.[StateLicenseTypeID], changes.[AppValidation])
OUTPUT INSERTED.[ApplicationID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblApplication] OFF;
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
[DataSync].[tblApplication_dss_tracking] side JOIN 
(SELECT p.[ApplicationID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[ApplicationID] = t.[ApplicationID]) AS changes ON changes.[ApplicationID] = side.[ApplicationID]
SELECT [ApplicationID] FROM @changeTable t WHERE NOT EXISTS (SELECT [ApplicationID] from @changed i WHERE t.[ApplicationID] = i.[ApplicationID])
END