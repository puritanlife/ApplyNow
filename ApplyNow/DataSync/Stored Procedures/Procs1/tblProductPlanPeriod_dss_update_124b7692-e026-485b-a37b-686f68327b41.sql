CREATE PROCEDURE [DataSync].[tblProductPlanPeriod_dss_update_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 Int,
	@P_5 Float,
	@P_6 Float,
	@P_7 Float,
	@P_8 DateTime,
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 DateTime,
	@sync_force_write Int,
	@sync_min_timestamp BigInt,
	@sync_row_count Int OUTPUT
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
WHERE [object_id] = 1138103095 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1138103095 
 AND [owner_scope_local_id] = 3
SET @sync_row_count = 0; UPDATE [dbo].[tblProductPlanPeriod] SET [ProductTypeID] = @P_2, [PlanTypeID] = @P_3, [PeriodTypeID] = @P_4, [PremMin] = @P_5, [PremMax] = @P_6, [CreditingRate] = @P_7, [EffectiveDate] = @P_8, [EndDate] = @P_9, [CreatedDate] = @P_10, [LastModifiedDate] = @P_11 FROM [dbo].[tblProductPlanPeriod] [base] LEFT JOIN [DataSync].[tblProductPlanPeriod_dss_tracking] [side] ON [base].[ProductPlanPeriodID] = [side].[ProductPlanPeriodID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[ProductPlanPeriodID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END