CREATE TABLE [dbo].[tblPPPWithRider] (
    [PPPWithRiderID]      INT      IDENTITY (1, 1) NOT NULL,
    [ProductPlanPeriodID] INT      NOT NULL,
    [RiderTypeID]         INT      NOT NULL,
    [CreatedDate]         DATETIME CONSTRAINT [DF_tblPPPWithRiderCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]    DATETIME CONSTRAINT [DF_tblPPPWithRiderLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblPPPWithRiderID] PRIMARY KEY CLUSTERED ([PPPWithRiderID] ASC),
    CONSTRAINT [FK_PPPRProductPlanPeriodID] FOREIGN KEY ([ProductPlanPeriodID]) REFERENCES [dbo].[tblProductPlanPeriod] ([ProductPlanPeriodID]),
    CONSTRAINT [FK_PPPRRiderTypeID] FOREIGN KEY ([RiderTypeID]) REFERENCES [dbo].[tblRiderType] ([RiderTypeID])
);


GO
CREATE TRIGGER [dbo].[tblPPPWithRider_dss_insert_trigger] ON [dbo].[tblPPPWithRider] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1106102981 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPPPWithRider_dss_tracking] AS [target] 
USING (SELECT [i].[PPPWithRiderID] FROM INSERTED AS [i]) AS source([PPPWithRiderID]) 
ON ([target].[PPPWithRiderID] = [source].[PPPWithRiderID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PPPWithRiderID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PPPWithRiderID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER trg_tblPPPWithRiderLastModifiedDate
ON [dbo].[tblPPPWithRider]
AFTER UPDATE
AS
    UPDATE [dbo].[tblPPPWithRider]
    SET [LastModifiedDate] = GETDATE()
    WHERE [PPPWithRiderID] IN (SELECT [PPPWithRiderID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblPPPWithRider_dss_delete_trigger] ON [dbo].[tblPPPWithRider] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1106102981 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPPPWithRider_dss_tracking] AS [target] 
USING (SELECT [i].[PPPWithRiderID] FROM DELETED AS [i]) AS source([PPPWithRiderID]) 
ON ([target].[PPPWithRiderID] = [source].[PPPWithRiderID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PPPWithRiderID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PPPWithRiderID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblPPPWithRider_dss_update_trigger] ON [dbo].[tblPPPWithRider] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1106102981 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPPPWithRider_dss_tracking] AS [target] 
USING (SELECT [i].[PPPWithRiderID] FROM INSERTED AS [i]) AS source([PPPWithRiderID]) 
ON ([target].[PPPWithRiderID] = [source].[PPPWithRiderID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PPPWithRiderID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PPPWithRiderID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );