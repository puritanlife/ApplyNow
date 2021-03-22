CREATE PROCEDURE [DataSync].[tblPerson_dss_bulkinsert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblPerson_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([PersonID] int, PRIMARY KEY ([PersonID]));

SET IDENTITY_INSERT [dbo].[tblPerson] ON;
-- update/insert into the base table
MERGE [dbo].[tblPerson] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblPerson_dss_tracking] t ON p.[PersonID] = t.[PersonID]) AS changes ON changes.[PersonID] = base.[PersonID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([PersonID], [BusinessName], [FirstName], [MiddleName], [LastName], [DOB], [ResidentAlien], [USCitizen], [GenderTypeID], [SSNTINTypeID], [BirthStateID], [IDNumber], [SSNTIN], [UUID], [CreatedDate], [LastModifiedDate]) VALUES (changes.[PersonID], changes.[BusinessName], changes.[FirstName], changes.[MiddleName], changes.[LastName], changes.[DOB], changes.[ResidentAlien], changes.[USCitizen], changes.[GenderTypeID], changes.[SSNTINTypeID], changes.[BirthStateID], changes.[IDNumber], changes.[SSNTIN], changes.[UUID], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[PersonID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblPerson] OFF;
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
[DataSync].[tblPerson_dss_tracking] side JOIN 
(SELECT p.[PersonID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[PersonID] = t.[PersonID]) AS changes ON changes.[PersonID] = side.[PersonID]
SELECT [PersonID] FROM @changeTable t WHERE NOT EXISTS (SELECT [PersonID] from @changed i WHERE t.[PersonID] = i.[PersonID])
END