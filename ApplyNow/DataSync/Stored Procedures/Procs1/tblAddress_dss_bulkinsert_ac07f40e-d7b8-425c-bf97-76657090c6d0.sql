CREATE PROCEDURE [DataSync].[tblAddress_dss_bulkinsert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblAddress_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([AddressID] int, PRIMARY KEY ([AddressID]));

SET IDENTITY_INSERT [dbo].[tblAddress] ON;
-- update/insert into the base table
MERGE [dbo].[tblAddress] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblAddress_dss_tracking] t ON p.[AddressID] = t.[AddressID]) AS changes ON changes.[AddressID] = base.[AddressID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([AddressID], [PersonID], [AddressTypeID], [Address1], [Address2], [City], [StateID], [ZipCode], [CreatedDate], [LastModifiedDate]) VALUES (changes.[AddressID], changes.[PersonID], changes.[AddressTypeID], changes.[Address1], changes.[Address2], changes.[City], changes.[StateID], changes.[ZipCode], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[AddressID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblAddress] OFF;
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
[DataSync].[tblAddress_dss_tracking] side JOIN 
(SELECT p.[AddressID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[AddressID] = t.[AddressID]) AS changes ON changes.[AddressID] = side.[AddressID]
SELECT [AddressID] FROM @changeTable t WHERE NOT EXISTS (SELECT [AddressID] from @changed i WHERE t.[AddressID] = i.[AddressID])
END