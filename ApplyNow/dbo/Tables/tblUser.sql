CREATE TABLE [dbo].[tblUser] (
    [UserId]              INT           IDENTITY (1, 1) NOT NULL,
    [PersonID]            INT           NOT NULL,
    [UserTypeID]          INT           NOT NULL,
    [Email]               VARCHAR (75)  NOT NULL,
    [Pass]                VARCHAR (60)  NOT NULL,
    [Attempt]             INT           NULL,
    [locked]              BIT           NOT NULL,
    [Last_Login]          DATETIME      NULL,
    [IsAdmin]             BIT           NOT NULL,
    [PasswordChangeDate]  DATETIME      NULL,
    [Question1]           VARCHAR (255) NULL,
    [Answer1]             VARCHAR (255) NULL,
    [Question2]           VARCHAR (255) NULL,
    [Answer2]             VARCHAR (255) NULL,
    [Question3]           VARCHAR (255) NULL,
    [Answer3]             VARCHAR (255) NULL,
    [Question1ChangeDate] DATETIME      NULL,
    [Answer1ChangeDate]   DATETIME      NULL,
    [Question2ChangeDate] DATETIME      NULL,
    [Answer2ChangeDate]   DATETIME      NULL,
    [Question3ChangeDate] DATETIME      NULL,
    [Answer3ChangeDate]   DATETIME      NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_tblUserCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]    DATETIME      CONSTRAINT [DF_tblUserLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [FK_UserPersonID] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[tblPerson] ([PersonID]),
    CONSTRAINT [FK_UserUserTypeID] FOREIGN KEY ([UserTypeID]) REFERENCES [dbo].[tblUserType] ([UserTypeID]),
    CONSTRAINT [UQ__UNINON_tblUser] UNIQUE NONCLUSTERED ([Email] ASC),
    CONSTRAINT [UQ_CON_tblUser_Email] UNIQUE NONCLUSTERED ([Email] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblUser].[Email]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblUser].[Pass]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblUser].[PasswordChangeDate]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO

CREATE TRIGGER trg_tblUserLastModifiedDate
ON [dbo].[tblUser]
AFTER UPDATE
AS
    UPDATE [dbo].[tblUser]
    SET [LastModifiedDate] = GETDATE()
    WHERE [UserId] IN (SELECT [UserId] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblUser_dss_insert_trigger] ON [dbo].[tblUser] FOR INSERT AS
SET NOCOUNT ON
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

MERGE [DataSync].[tblUser_dss_tracking] AS [target] 
USING (SELECT [i].[UserId] FROM INSERTED AS [i]) AS source([UserId]) 
ON ([target].[UserId] = [source].[UserId])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[UserId] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[UserId],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblUser_dss_delete_trigger] ON [dbo].[tblUser] FOR DELETE AS
SET NOCOUNT ON
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

MERGE [DataSync].[tblUser_dss_tracking] AS [target] 
USING (SELECT [i].[UserId] FROM DELETED AS [i]) AS source([UserId]) 
ON ([target].[UserId] = [source].[UserId])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[UserId] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[UserId],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblUser_dss_update_trigger] ON [dbo].[tblUser] FOR UPDATE AS
SET NOCOUNT ON
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

MERGE [DataSync].[tblUser_dss_tracking] AS [target] 
USING (SELECT [i].[UserId] FROM INSERTED AS [i]) AS source([UserId]) 
ON ([target].[UserId] = [source].[UserId])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[UserId] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[UserId],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );