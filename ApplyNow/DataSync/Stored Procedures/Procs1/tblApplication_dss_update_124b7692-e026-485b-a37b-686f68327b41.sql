CREATE PROCEDURE [DataSync].[tblApplication_dss_update_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 Int,
	@P_3 NVarChar(250),
	@P_4 Int,
	@P_5 Float,
	@P_6 Bit,
	@P_7 Int,
	@P_8 NVarChar(100),
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 Int,
	@P_12 Int,
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
WHERE [object_id] = 434100587 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 434100587 
 AND [owner_scope_local_id] = 3
SET @sync_row_count = 0; UPDATE [dbo].[tblApplication] SET [ProductPlanPeriodID] = @P_2, [UUID] = @P_3, [StateID] = @P_4, [Premium] = @P_5, [ForCompany] = @P_6, [StatusTypeID] = @P_7, [CanvasPolicyNumber] = @P_8, [CreatedDate] = @P_9, [LastModifiedDate] = @P_10, [StateLicenseTypeID] = @P_11, [AppValidation] = @P_12 FROM [dbo].[tblApplication] [base] LEFT JOIN [DataSync].[tblApplication_dss_tracking] [side] ON [base].[ApplicationID] = [side].[ApplicationID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[ApplicationID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END