CREATE PROCEDURE [DataSync].[tblLogCatchingErrors_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 NVarChar(max),
	@P_3 NVarChar(max),
	@P_4 NVarChar(max),
	@P_5 NVarChar(max),
	@P_6 NVarChar(max),
	@P_7 NVarChar(max),
	@P_8 DateTime,
	@P_9 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [maint].[tblLogCatchingErrors] WHERE [LogCatchingErrorsID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblLogCatchingErrors_dss_tracking] WHERE [LogCatchingErrorsID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [maint].[tblLogCatchingErrors] ON; INSERT INTO [maint].[tblLogCatchingErrors]([LogCatchingErrorsID], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorMessage], [ErrorParameters], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [maint].[tblLogCatchingErrors] OFF; END 
END