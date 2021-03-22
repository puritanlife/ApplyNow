CREATE TABLE [maint].[tblLogCatchingErrors] (
    [LogCatchingErrorsID] INT            IDENTITY (1, 1) NOT NULL,
    [ErrorNumber]         NVARCHAR (MAX) NULL,
    [ErrorSeverity]       NVARCHAR (MAX) NULL,
    [ErrorState]          NVARCHAR (MAX) NULL,
    [ErrorProcedure]      NVARCHAR (MAX) NULL,
    [ErrorMessage]        NVARCHAR (MAX) NULL,
    [ErrorParameters]     NVARCHAR (MAX) NULL,
    [CreatedDate]         DATETIME       CONSTRAINT [DF_tblLogCatchingErrorsCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]    DATETIME       CONSTRAINT [DF_tblLogCatchingErrorsLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblLogCatchingErrors] PRIMARY KEY CLUSTERED ([LogCatchingErrorsID] ASC)
);


GO
CREATE TRIGGER [maint].[tblLogCatchingErrors_dss_update_trigger] ON [maint].[tblLogCatchingErrors] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 226099846 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLogCatchingErrors_dss_tracking] AS [target] 
USING (SELECT [i].[LogCatchingErrorsID] FROM INSERTED AS [i]) AS source([LogCatchingErrorsID]) 
ON ([target].[LogCatchingErrorsID] = [source].[LogCatchingErrorsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LogCatchingErrorsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LogCatchingErrorsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [maint].[tblLogCatchingErrors_dss_insert_trigger] ON [maint].[tblLogCatchingErrors] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 226099846 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLogCatchingErrors_dss_tracking] AS [target] 
USING (SELECT [i].[LogCatchingErrorsID] FROM INSERTED AS [i]) AS source([LogCatchingErrorsID]) 
ON ([target].[LogCatchingErrorsID] = [source].[LogCatchingErrorsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LogCatchingErrorsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LogCatchingErrorsID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER maint.tblNewErrorNotification on [maint].[tblLogCatchingErrors]
AFTER INSERT
AS BEGIN

	DECLARE @EmailBody nvarchar(max)
		   ,@ErrorID nvarchar(10)
		   ,@ErrorNumber nvarchar(10)
		   ,@ErrorProcedure nvarchar(50)
		   ,@ErrorMessage nvarchar(1000)
		   ,@ErrorParameters nvarchar(1000)
	select @ErrorID = inserted.LogCatchingErrorsID	
	,@ErrorNumber = inserted.ErrorNumber
	,@ErrorProcedure = inserted.ErrorProcedure
	,@ErrorMessage = inserted.ErrorMessage
	,@ErrorParameters = inserted.ErrorParameters
	FROM inserted

	SET @EmailBody = N'<html>
					   <body>
					   <br>
					   <h5>New Error Received</h5> 
					   <br>'
	SET @EmailBody += N'<b>Error ID</b> : ' + @ErrorID
	SET @EmailBody += N'<br>'
	SET @EmailBody += N'<b>Error Number</b> : ' + @ErrorNumber
	SET @EmailBody += N'<br>'
	SET @EmailBody += N'<b>Procedure</b> : ' + @ErrorProcedure
	SET @EmailBody += N'<br>'
	SET @EmailBody += N'<b>Error Message</b> : ' + @ErrorMessage
	SET @EmailBody += N'<br>'
	SET @EmailBody += N'<b>Error Parameters</b> : ' + @ErrorParameters
	SET @EmailBody += N'<br>'
	SET @EmailBody += N'
				</body>
				</html>'

	INSERT INTO dbo.tblNewErrorNotification
	(EmailBody)
	VALUES
	(@EmailBody)

END
GO
CREATE TRIGGER [maint].[tblLogCatchingErrors_dss_delete_trigger] ON [maint].[tblLogCatchingErrors] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 226099846 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLogCatchingErrors_dss_tracking] AS [target] 
USING (SELECT [i].[LogCatchingErrorsID] FROM DELETED AS [i]) AS source([LogCatchingErrorsID]) 
ON ([target].[LogCatchingErrorsID] = [source].[LogCatchingErrorsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LogCatchingErrorsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LogCatchingErrorsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );