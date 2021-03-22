CREATE PROCEDURE [DataSync].[tblProductPlanPeriod_dss_bulkinsert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@sync_min_timestamp BigInt,
	@sync_scope_local_id Int,
	@changeTable [DataSync].[tblProductPlanPeriod_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
DECLARE @changed TABLE ([ProductPlanPeriodID] int, PRIMARY KEY ([ProductPlanPeriodID]));

SET IDENTITY_INSERT [dbo].[tblProductPlanPeriod] ON;
-- update/insert into the base table
MERGE [dbo].[tblProductPlanPeriod] AS base USING
-- join done here against the side table to get the local timestamp for concurrency check
(SELECT p.*, t.local_update_peer_timestamp FROM @changeTable p LEFT JOIN [DataSync].[tblProductPlanPeriod_dss_tracking] t ON p.[ProductPlanPeriodID] = t.[ProductPlanPeriodID]) AS changes ON changes.[ProductPlanPeriodID] = base.[ProductPlanPeriodID]
WHEN NOT MATCHED BY TARGET AND changes.local_update_peer_timestamp <= @sync_min_timestamp OR changes.local_update_peer_timestamp IS NULL THEN
INSERT ([ProductPlanPeriodID], [ProductTypeID], [PlanTypeID], [PeriodTypeID], [PremMin], [PremMax], [CreditingRate], [EffectiveDate], [EndDate], [CreatedDate], [LastModifiedDate]) VALUES (changes.[ProductPlanPeriodID], changes.[ProductTypeID], changes.[PlanTypeID], changes.[PeriodTypeID], changes.[PremMin], changes.[PremMax], changes.[CreditingRate], changes.[EffectiveDate], changes.[EndDate], changes.[CreatedDate], changes.[LastModifiedDate])
OUTPUT INSERTED.[ProductPlanPeriodID] INTO @changed; -- populates the temp table with successful PKs

SET IDENTITY_INSERT [dbo].[tblProductPlanPeriod] OFF;
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
[DataSync].[tblProductPlanPeriod_dss_tracking] side JOIN 
(SELECT p.[ProductPlanPeriodID], p.sync_update_peer_timestamp, p.sync_update_peer_key, p.sync_create_peer_key, p.sync_create_peer_timestamp FROM @changed t JOIN @changeTable p ON p.[ProductPlanPeriodID] = t.[ProductPlanPeriodID]) AS changes ON changes.[ProductPlanPeriodID] = side.[ProductPlanPeriodID]
SELECT [ProductPlanPeriodID] FROM @changeTable t WHERE NOT EXISTS (SELECT [ProductPlanPeriodID] from @changed i WHERE t.[ProductPlanPeriodID] = i.[ProductPlanPeriodID])
END