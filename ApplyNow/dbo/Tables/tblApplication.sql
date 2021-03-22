CREATE TABLE [dbo].[tblApplication] (
    [ApplicationID]       INT            IDENTITY (1, 1) NOT NULL,
    [ProductPlanPeriodID] INT            NOT NULL,
    [UUID]                NVARCHAR (250) NULL,
    [StateID]             INT            NOT NULL,
    [Premium]             FLOAT (53)     NULL,
    [ForCompany]          BIT            NOT NULL,
    [StatusTypeID]        INT            NOT NULL,
    [CanvasPolicyNumber]  NVARCHAR (100) NULL,
    [CreatedDate]         DATETIME       CONSTRAINT [DF_tblApplicationCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]    DATETIME       CONSTRAINT [DF_tblApplicationLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    [StateLicenseTypeID]  INT            NOT NULL,
    [AppValidation]       INT            CONSTRAINT [DF_AppValidation] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblApplication] PRIMARY KEY CLUSTERED ([ApplicationID] ASC),
    CONSTRAINT [FK_ApplicationProductPlanPeriodID] FOREIGN KEY ([ProductPlanPeriodID]) REFERENCES [dbo].[tblProductPlanPeriod] ([ProductPlanPeriodID]),
    CONSTRAINT [FK_ApplicationStateID] FOREIGN KEY ([StateID]) REFERENCES [dbo].[tblState] ([StateID]),
    CONSTRAINT [FK_ApplicationStateLicenseTypeID] FOREIGN KEY ([StateLicenseTypeID]) REFERENCES [dbo].[tblStateLicenseType] ([StateLicenseTypeID]),
    CONSTRAINT [FK_ApplicationStatusTypeID] FOREIGN KEY ([StatusTypeID]) REFERENCES [dbo].[tblStatusType] ([StatusTypeID])
);


GO
CREATE TRIGGER [dbo].[tblApplication_dss_insert_trigger] ON [dbo].[tblApplication] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 434100587 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblApplication_dss_tracking] AS [target] 
USING (SELECT [i].[ApplicationID] FROM INSERTED AS [i]) AS source([ApplicationID]) 
ON ([target].[ApplicationID] = [source].[ApplicationID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ApplicationID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ApplicationID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER trg_tblApplicationLastModifiedDate
ON [dbo].[tblApplication]
AFTER UPDATE
AS
    UPDATE [dbo].[tblApplication]
    SET [LastModifiedDate] = GETDATE()
    WHERE [ApplicationID] IN (SELECT [ApplicationID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblApplication_dss_delete_trigger] ON [dbo].[tblApplication] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 434100587 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblApplication_dss_tracking] AS [target] 
USING (SELECT [i].[ApplicationID] FROM DELETED AS [i]) AS source([ApplicationID]) 
ON ([target].[ApplicationID] = [source].[ApplicationID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ApplicationID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ApplicationID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblApplication_dss_update_trigger] ON [dbo].[tblApplication] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 434100587 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblApplication_dss_tracking] AS [target] 
USING (SELECT [i].[ApplicationID] FROM INSERTED AS [i]) AS source([ApplicationID]) 
ON ([target].[ApplicationID] = [source].[ApplicationID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ApplicationID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ApplicationID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );