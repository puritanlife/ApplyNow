CREATE PROCEDURE [DataSync].[tblAddress_dss_update_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 NVarChar(max),
	@P_5 NVarChar(max),
	@P_6 NVarChar(max),
	@P_7 Int,
	@P_8 NVarChar(max),
	@P_9 DateTime,
	@P_10 DateTime,
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
WHERE [object_id] = 258099960 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 258099960 
 AND [owner_scope_local_id] = 2
SET @sync_row_count = 0; UPDATE [dbo].[tblAddress] SET [PersonID] = @P_2, [AddressTypeID] = @P_3, [Address1] = @P_4, [Address2] = @P_5, [City] = @P_6, [StateID] = @P_7, [ZipCode] = @P_8, [CreatedDate] = @P_9, [LastModifiedDate] = @P_10 FROM [dbo].[tblAddress] [base] LEFT JOIN [DataSync].[tblAddress_dss_tracking] [side] ON [base].[AddressID] = [side].[AddressID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[AddressID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END