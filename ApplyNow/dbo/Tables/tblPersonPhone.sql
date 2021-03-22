CREATE TABLE [dbo].[tblPersonPhone] (
    [PersonPhoneID]    INT            IDENTITY (1, 1) NOT NULL,
    [PersonID]         INT            NOT NULL,
    [PhoneTypeID]      INT            NOT NULL,
    [PhoneNumber]      NVARCHAR (MAX) NULL,
    [CreatedDate]      DATETIME       CONSTRAINT [DF_tblPersonPhoneCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME       CONSTRAINT [DF_tblPersonPhoneLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblPersonPhone] PRIMARY KEY CLUSTERED ([PersonPhoneID] ASC),
    CONSTRAINT [FK_PersonPhonePersonID] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[tblPerson] ([PersonID]),
    CONSTRAINT [FK_PersonPhonePhoneTypeID] FOREIGN KEY ([PhoneTypeID]) REFERENCES [dbo].[tblPhoneType] ([PhoneTypeID])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPersonPhone].[PersonPhoneID]
    WITH (LABEL = 'Confidential', LABEL_ID = '331F0B13-76B5-2F1B-A77B-DEF5A73C73C2', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5C503E21-22C6-81FA-620B-F369B8EC38D1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPersonPhone].[PhoneTypeID]
    WITH (LABEL = 'Confidential', LABEL_ID = '331F0B13-76B5-2F1B-A77B-DEF5A73C73C2', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5C503E21-22C6-81FA-620B-F369B8EC38D1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPersonPhone].[PhoneNumber]
    WITH (LABEL = 'Confidential', LABEL_ID = '331F0B13-76B5-2F1B-A77B-DEF5A73C73C2', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5C503E21-22C6-81FA-620B-F369B8EC38D1', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblPersonPhone_dss_insert_trigger] ON [dbo].[tblPersonPhone] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 946102411 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPersonPhone_dss_tracking] AS [target] 
USING (SELECT [i].[PersonPhoneID] FROM INSERTED AS [i]) AS source([PersonPhoneID]) 
ON ([target].[PersonPhoneID] = [source].[PersonPhoneID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PersonPhoneID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PersonPhoneID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER trg_tblPersonPhoneLastModifiedDate
ON [dbo].[tblPersonPhone]
AFTER UPDATE
AS
    UPDATE [dbo].[tblPersonPhone]
    SET [LastModifiedDate] = GETDATE()
    WHERE [PersonPhoneID] IN (SELECT [PersonPhoneID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblPersonPhone_dss_delete_trigger] ON [dbo].[tblPersonPhone] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 946102411 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPersonPhone_dss_tracking] AS [target] 
USING (SELECT [i].[PersonPhoneID] FROM DELETED AS [i]) AS source([PersonPhoneID]) 
ON ([target].[PersonPhoneID] = [source].[PersonPhoneID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PersonPhoneID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PersonPhoneID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblPersonPhone_dss_update_trigger] ON [dbo].[tblPersonPhone] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 946102411 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPersonPhone_dss_tracking] AS [target] 
USING (SELECT [i].[PersonPhoneID] FROM INSERTED AS [i]) AS source([PersonPhoneID]) 
ON ([target].[PersonPhoneID] = [source].[PersonPhoneID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PersonPhoneID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PersonPhoneID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );