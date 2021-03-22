CREATE PROCEDURE [DataSync].[tblPlaidStripeDataElements_dss_update_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 Int,
	@P_3 Bit,
	@P_4 NVarChar(250),
	@P_5 Float,
	@P_6 Int,
	@P_7 DateTime,
	@P_8 DateTime,
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
WHERE [object_id] = 1042102753 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1042102753 
 AND [owner_scope_local_id] = 1
SET @sync_row_count = 0; UPDATE [dbo].[tblPlaidStripeDataElements] SET [ApplyNowID] = @P_2, [Charged] = @P_3, [PlaidStripeID] = @P_4, [PaymentAmount] = @P_5, [PaymentMethodTypeID] = @P_6, [CreatedDate] = @P_7, [LastModifiedDate] = @P_8 FROM [dbo].[tblPlaidStripeDataElements] [base] LEFT JOIN [DataSync].[tblPlaidStripeDataElements_dss_tracking] [side] ON [base].[PlaidStripeDataElementsID] = [side].[PlaidStripeDataElementsID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[PlaidStripeDataElementsID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END