CREATE PROCEDURE [DataSync].[tblDocuSignDataElements_dss_bulkupdate_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblDocuSignDataElements_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] READONLY
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
WHERE [object_id] = 498100815 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 498100815 
 AND [owner_scope_local_id] = 2
-- use a temp table to store the list of PKs that successfully got updated
declare @changed TABLE ([DocuSignDataElementsID] int, PRIMARY KEY ([DocuSignDataElementsID]));

SET IDENTITY_INSERT [dbo].[tblDocuSignDataElements] ON;
-- update the base table
MERGE [dbo].[tblDocuSignDataElements] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.update_scope_local_id, t.scope_update_peer_key, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblDocuSignDataElements_dss_tracking] t ON p.[DocuSignDataElementsID] = t.[DocuSignDataElementsID]) as changes ON changes.[DocuSignDataElementsID] = base.[DocuSignDataElementsID]
WHEN MATCHED AND (changes.update_scope_local_id = @sync_scope_local_id AND changes.scope_update_peer_key = changes.sync_update_peer_key) OR changes.local_update_peer_timestamp <= @sync_min_timestamp-- No tracking record exists
OR (changes.update_scope_local_id IS NULL AND changes.scope_update_peer_key IS NULL AND changes.local_update_peer_timestamp IS NULL) 
 THEN
UPDATE SET [ApplyNowID] = changes.[ApplyNowID], [Signature] = changes.[Signature], [CreatedDate] = changes.[CreatedDate], [LastModifiedDate] = changes.[LastModifiedDate]
OUTPUT INSERTED.[DocuSignDataElementsID] into @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblDocuSignDataElements] OFF;
UPDATE side SET
update_scope_local_id = @sync_scope_local_id, 
scope_update_peer_key = changes.sync_update_peer_key, 
scope_update_peer_timestamp = changes.sync_update_peer_timestamp,
local_update_peer_key = 0
FROM 
[DataSync].[tblDocuSignDataElements_dss_tracking] side JOIN 
(SELECT p.[DocuSignDataElementsID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[DocuSignDataElementsID] = t.[DocuSignDataElementsID]) as changes ON changes.[DocuSignDataElementsID] = side.[DocuSignDataElementsID]
SELECT [DocuSignDataElementsID] FROM @changeTable t WHERE NOT EXISTS (SELECT [DocuSignDataElementsID] from @changed i WHERE t.[DocuSignDataElementsID] = i.[DocuSignDataElementsID])
END