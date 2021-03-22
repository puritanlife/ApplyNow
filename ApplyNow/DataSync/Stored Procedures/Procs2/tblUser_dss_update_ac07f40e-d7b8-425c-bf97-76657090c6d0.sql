CREATE PROCEDURE [DataSync].[tblUser_dss_update_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 VarChar(75),
	@P_5 VarChar(60),
	@P_6 Int,
	@P_7 Bit,
	@P_8 DateTime,
	@P_9 Bit,
	@P_10 DateTime,
	@P_11 VarChar(255),
	@P_12 VarChar(255),
	@P_13 VarChar(255),
	@P_14 VarChar(255),
	@P_15 VarChar(255),
	@P_16 VarChar(255),
	@P_17 DateTime,
	@P_18 DateTime,
	@P_19 DateTime,
	@P_20 DateTime,
	@P_21 DateTime,
	@P_22 DateTime,
	@P_23 DateTime,
	@P_24 DateTime,
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
WHERE [object_id] = 1490104349 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1490104349 
 AND [owner_scope_local_id] = 2
SET @sync_row_count = 0; UPDATE [dbo].[tblUser] SET [PersonID] = @P_2, [UserTypeID] = @P_3, [Email] = @P_4, [Pass] = @P_5, [Attempt] = @P_6, [locked] = @P_7, [Last_Login] = @P_8, [IsAdmin] = @P_9, [PasswordChangeDate] = @P_10, [Question1] = @P_11, [Answer1] = @P_12, [Question2] = @P_13, [Answer2] = @P_14, [Question3] = @P_15, [Answer3] = @P_16, [Question1ChangeDate] = @P_17, [Answer1ChangeDate] = @P_18, [Question2ChangeDate] = @P_19, [Answer2ChangeDate] = @P_20, [Question3ChangeDate] = @P_21, [Answer3ChangeDate] = @P_22, [CreatedDate] = @P_23, [LastModifiedDate] = @P_24 FROM [dbo].[tblUser] [base] LEFT JOIN [DataSync].[tblUser_dss_tracking] [side] ON [base].[UserId] = [side].[UserId] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[UserId] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END