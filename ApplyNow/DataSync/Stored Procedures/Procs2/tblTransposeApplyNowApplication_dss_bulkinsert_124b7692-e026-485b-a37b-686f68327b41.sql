CREATE PROCEDURE [DataSync].[tblTransposeApplyNowApplication_dss_bulkinsert_124b7692-e026-485b-a37b-686f68327b41]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblTransposeApplyNowApplication_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([TransposeApplyNowApplicationID] int, PRIMARY KEY ([TransposeApplyNowApplicationID]));

SET IDENTITY_INSERT [dbo].[tblTransposeApplyNowApplication] ON;
-- update/insert into the base table
MERGE [dbo].[tblTransposeApplyNowApplication] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblTransposeApplyNowApplication_dss_tracking] t ON p.[TransposeApplyNowApplicationID] = t.[TransposeApplyNowApplicationID]) AS changes ON changes.[TransposeApplyNowApplicationID] = base.[TransposeApplyNowApplicationID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([TransposeApplyNowApplicationID], [ApplicationID], [ApplyNowIDOwner], [ApplyNowIDJointOwner], [ApplyNowIDAnnuitant], [ApplyNowIDJointAnnuitant], [ApplyNowIDBeneficiary1], [ApplyNowIDBeneficiary2], [ApplyNowIDBeneficiary3], [ApplyNowIDBeneficiary4], [ApplyNowIDBeneficiary5], [ApplyNowIDReplacementCompany], [ApplyNowIDUnknown], [ApplyNowIDAgent], [CreatedDate], [LastModifiedDate]) VALUES (changes.[TransposeApplyNowApplicationID], changes.[ApplicationID], changes.[ApplyNowIDOwner], changes.[ApplyNowIDJointOwner], changes.[ApplyNowIDAnnuitant], changes.[ApplyNowIDJointAnnuitant], changes.[ApplyNowIDBeneficiary1], changes.[ApplyNowIDBeneficiary2], changes.[ApplyNowIDBeneficiary3], changes.[ApplyNowIDBeneficiary4], changes.[ApplyNowIDBeneficiary5], changes.[ApplyNowIDReplacementCompany], changes.[ApplyNowIDUnknown], changes.[ApplyNowIDAgent], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[TransposeApplyNowApplicationID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblTransposeApplyNowApplication] OFF;
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
[DataSync].[tblTransposeApplyNowApplication_dss_tracking] side JOIN 
(SELECT p.[TransposeApplyNowApplicationID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[TransposeApplyNowApplicationID] = t.[TransposeApplyNowApplicationID]) AS changes ON changes.[TransposeApplyNowApplicationID] = side.[TransposeApplyNowApplicationID]
SELECT [TransposeApplyNowApplicationID] FROM @changeTable t WHERE NOT EXISTS (SELECT [TransposeApplyNowApplicationID] from @changed i WHERE t.[TransposeApplyNowApplicationID] = i.[TransposeApplyNowApplicationID])
END