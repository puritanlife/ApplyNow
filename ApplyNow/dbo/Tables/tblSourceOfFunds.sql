CREATE TABLE [dbo].[tblSourceOfFunds] (
    [SourceOfFundsID]  INT      IDENTITY (1, 1) NOT NULL,
    [ApplicationID]    INT      NOT NULL,
    [FundsTypeID]      INT      NOT NULL,
    [Contribution]     BIT      NULL,
    [ContributionYear] INT      NOT NULL,
    [Transfer]         BIT      NOT NULL,
    [Rollover]         BIT      NOT NULL,
    [Conversion]       BIT      NULL,
    [ConversionYear]   INT      NOT NULL,
    [CreatedDate]      DATETIME CONSTRAINT [DF_tblSourceOfFundsCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME CONSTRAINT [DF_tblSourceOfFundsLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblSourceOfFunds] PRIMARY KEY CLUSTERED ([SourceOfFundsID] ASC),
    CONSTRAINT [FK_SourceOfFundsApplicationID] FOREIGN KEY ([ApplicationID]) REFERENCES [dbo].[tblApplication] ([ApplicationID]),
    CONSTRAINT [FK_SourceOfFundsFundsTypeID] FOREIGN KEY ([FundsTypeID]) REFERENCES [dbo].[tblFundsType] ([FundsTypeID])
);


GO
CREATE TRIGGER [dbo].[tblSourceOfFunds_dss_update_trigger] ON [dbo].[tblSourceOfFunds] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 299148111 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblSourceOfFunds_dss_tracking] AS [target] 
USING (SELECT [i].[SourceOfFundsID] FROM INSERTED AS [i]) AS source([SourceOfFundsID]) 
ON ([target].[SourceOfFundsID] = [source].[SourceOfFundsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[SourceOfFundsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[SourceOfFundsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblSourceOfFunds_dss_insert_trigger] ON [dbo].[tblSourceOfFunds] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 299148111 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblSourceOfFunds_dss_tracking] AS [target] 
USING (SELECT [i].[SourceOfFundsID] FROM INSERTED AS [i]) AS source([SourceOfFundsID]) 
ON ([target].[SourceOfFundsID] = [source].[SourceOfFundsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[SourceOfFundsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[SourceOfFundsID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER [dbo].[trg_tblSourceOfFundsLastModifiedDate]
ON [dbo].[tblSourceOfFunds]
AFTER UPDATE
AS
    UPDATE [dbo].[tblSourceOfFunds]
    SET [LastModifiedDate] = GETDATE()
    WHERE [SourceOfFundsID] IN (SELECT [SourceOfFundsID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblSourceOfFunds_dss_delete_trigger] ON [dbo].[tblSourceOfFunds] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 299148111 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblSourceOfFunds_dss_tracking] AS [target] 
USING (SELECT [i].[SourceOfFundsID] FROM DELETED AS [i]) AS source([SourceOfFundsID]) 
ON ([target].[SourceOfFundsID] = [source].[SourceOfFundsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[SourceOfFundsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[SourceOfFundsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );