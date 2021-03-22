CREATE TABLE [dbo].[tblPersonEmail] (
    [PersonEmailID]    INT            IDENTITY (1, 1) NOT NULL,
    [PersonID]         INT            NOT NULL,
    [EmailTypeID]      INT            NOT NULL,
    [EmailAddress]     NVARCHAR (MAX) NULL,
    [CreatedDate]      DATETIME       CONSTRAINT [DF_tblPersonEmailCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME       CONSTRAINT [DF_tblPersonEmailLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblPersonEmail] PRIMARY KEY CLUSTERED ([PersonEmailID] ASC),
    CONSTRAINT [FK_PersonEmailEmailTypeID] FOREIGN KEY ([EmailTypeID]) REFERENCES [dbo].[tblEmailType] ([EmailTypeID]),
    CONSTRAINT [FK_PersonEmailPersonID] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[tblPerson] ([PersonID])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPersonEmail].[EmailAddress]
    WITH (LABEL = 'Confidential', LABEL_ID = '331F0B13-76B5-2F1B-A77B-DEF5A73C73C2', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5C503E21-22C6-81FA-620B-F369B8EC38D1', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblPersonEmail_dss_insert_trigger] ON [dbo].[tblPersonEmail] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 914102297 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPersonEmail_dss_tracking] AS [target] 
USING (SELECT [i].[PersonEmailID] FROM INSERTED AS [i]) AS source([PersonEmailID]) 
ON ([target].[PersonEmailID] = [source].[PersonEmailID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PersonEmailID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PersonEmailID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER trg_tblPersonEmailLastModifiedDate
ON [dbo].[tblPersonEmail]
AFTER UPDATE
AS
    UPDATE [dbo].[tblPersonEmail]
    SET [LastModifiedDate] = GETDATE()
    WHERE [PersonEmailID] IN (SELECT [PersonEmailID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblPersonEmail_dss_delete_trigger] ON [dbo].[tblPersonEmail] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 914102297 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPersonEmail_dss_tracking] AS [target] 
USING (SELECT [i].[PersonEmailID] FROM DELETED AS [i]) AS source([PersonEmailID]) 
ON ([target].[PersonEmailID] = [source].[PersonEmailID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PersonEmailID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PersonEmailID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblPersonEmail_dss_update_trigger] ON [dbo].[tblPersonEmail] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 914102297 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPersonEmail_dss_tracking] AS [target] 
USING (SELECT [i].[PersonEmailID] FROM INSERTED AS [i]) AS source([PersonEmailID]) 
ON ([target].[PersonEmailID] = [source].[PersonEmailID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PersonEmailID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PersonEmailID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );