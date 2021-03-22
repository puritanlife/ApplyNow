CREATE PROCEDURE [DataSync].[tblLeadsNonLicenseStates_dss_bulkinsert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblLeadsNonLicenseStates_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([LeadsNonLicenseStatesID] int, PRIMARY KEY ([LeadsNonLicenseStatesID]));

SET IDENTITY_INSERT [dbo].[tblLeadsNonLicenseStates] ON;
-- update/insert into the base table
MERGE [dbo].[tblLeadsNonLicenseStates] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblLeadsNonLicenseStates_dss_tracking] t ON p.[LeadsNonLicenseStatesID] = t.[LeadsNonLicenseStatesID]) AS changes ON changes.[LeadsNonLicenseStatesID] = base.[LeadsNonLicenseStatesID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([LeadsNonLicenseStatesID], [ProductPlanPeriodID], [UUID], [StateID], [Premium], [StateLicenseTypeID], [Email], [CreatedDate], [LastModifiedDate]) VALUES (changes.[LeadsNonLicenseStatesID], changes.[ProductPlanPeriodID], changes.[UUID], changes.[StateID], changes.[Premium], changes.[StateLicenseTypeID], changes.[Email], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[LeadsNonLicenseStatesID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblLeadsNonLicenseStates] OFF;
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
[DataSync].[tblLeadsNonLicenseStates_dss_tracking] side JOIN 
(SELECT p.[LeadsNonLicenseStatesID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[LeadsNonLicenseStatesID] = t.[LeadsNonLicenseStatesID]) AS changes ON changes.[LeadsNonLicenseStatesID] = side.[LeadsNonLicenseStatesID]
SELECT [LeadsNonLicenseStatesID] FROM @changeTable t WHERE NOT EXISTS (SELECT [LeadsNonLicenseStatesID] from @changed i WHERE t.[LeadsNonLicenseStatesID] = i.[LeadsNonLicenseStatesID])
END