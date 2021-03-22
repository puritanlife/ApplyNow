CREATE PROCEDURE [DataSync].[tblLogStoredProcedureCalls_dss_insert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 NVarChar(max),
	@P_3 NVarChar(max),
	@P_4 NVarChar(max),
	@P_5 NVarChar(max),
	@P_6 DateTime,
	@P_7 DateTime,
	@P_8 DateTime,
	@P_9 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [maint].[tblLogStoredProcedureCalls] WHERE [LogStoredProcedureCallsID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblLogStoredProcedureCalls_dss_tracking] WHERE [LogStoredProcedureCallsID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [maint].[tblLogStoredProcedureCalls] ON; INSERT INTO [maint].[tblLogStoredProcedureCalls]([LogStoredProcedureCallsID], [Procedure], [Message], [Parameters], [Output], [StartSPCall], [EndSPCall], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [maint].[tblLogStoredProcedureCalls] OFF; END 
END