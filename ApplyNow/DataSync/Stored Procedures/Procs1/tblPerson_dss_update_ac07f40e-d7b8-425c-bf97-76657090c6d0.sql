CREATE PROCEDURE [DataSync].[tblPerson_dss_update_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 NVarChar(max),
	@P_3 NVarChar(max),
	@P_4 NVarChar(max),
	@P_5 NVarChar(max),
	@P_6 Date,
	@P_7 Bit,
	@P_8 Bit,
	@P_9 Int,
	@P_10 Int,
	@P_11 Int,
	@P_12 NVarChar(100),
	@P_13 NVarChar(100),
	@P_14 NVarChar(250),
	@P_15 DateTime,
	@P_16 DateTime,
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
WHERE [object_id] = 882102183 
 AND [owner_scope_local_id] = 0

DECLARE @marker_update_scope_local_id INT
DECLARE @marker_scope_update_peer_timestamp BIGINT
DECLARE @marker_scope_update_peer_key INT
DECLARE @marker_local_update_peer_timestamp BIGINT
DECLARE @marker_local_update_peer_key INT
SELECT TOP 1 @marker_update_scope_local_id = [provision_scope_local_id], @marker_local_update_peer_timestamp = [provision_timestamp], @marker_local_update_peer_key = [provision_local_peer_key], @marker_scope_update_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_update_peer_key = [provision_scope_peer_key]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 882102183 
 AND [owner_scope_local_id] = 2
SET @sync_row_count = 0; UPDATE [dbo].[tblPerson] SET [BusinessName] = @P_2, [FirstName] = @P_3, [MiddleName] = @P_4, [LastName] = @P_5, [DOB] = @P_6, [ResidentAlien] = @P_7, [USCitizen] = @P_8, [GenderTypeID] = @P_9, [SSNTINTypeID] = @P_10, [BirthStateID] = @P_11, [IDNumber] = @P_12, [SSNTIN] = @P_13, [UUID] = @P_14, [CreatedDate] = @P_15, [LastModifiedDate] = @P_16 FROM [dbo].[tblPerson] [base] LEFT JOIN [DataSync].[tblPerson_dss_tracking] [side] ON [base].[PersonID] = [side].[PersonID] WHERE ((CASE WHEN [side].[local_create_peer_timestamp] IS NOT NULL AND [side].[local_update_peer_timestamp] > @marker_local_update_peer_timestamp 
THEN [side].[local_update_peer_timestamp]
ELSE @marker_local_update_peer_timestamp
 END)  <= @sync_min_timestamp OR @sync_force_write = 1) AND ([base].[PersonID] = @P_1); SET @sync_row_count = @@ROWCOUNT;
END