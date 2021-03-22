CREATE TABLE [dbo].[tblProductPlanPeriod] (
    [ProductPlanPeriodID] INT        IDENTITY (1, 1) NOT NULL,
    [ProductTypeID]       INT        NOT NULL,
    [PlanTypeID]          INT        NOT NULL,
    [PeriodTypeID]        INT        NOT NULL,
    [PremMin]             FLOAT (53) NULL,
    [PremMax]             FLOAT (53) NULL,
    [CreditingRate]       FLOAT (53) NULL,
    [EffectiveDate]       DATETIME   NULL,
    [EndDate]             DATETIME   NULL,
    [CreatedDate]         DATETIME   CONSTRAINT [DF_tblProductPlanPeriodCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]    DATETIME   CONSTRAINT [DF_tblProductPlanPeriodLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblProductPlanPeriodID] PRIMARY KEY CLUSTERED ([ProductPlanPeriodID] ASC),
    CONSTRAINT [FK_PPPPeriodTypeID] FOREIGN KEY ([PeriodTypeID]) REFERENCES [dbo].[tblPeriodType] ([PeriodTypeID]),
    CONSTRAINT [FK_PPPPlanTypeID] FOREIGN KEY ([PlanTypeID]) REFERENCES [dbo].[tblPlanType] ([PlanTypeID]),
    CONSTRAINT [FK_PPPProductTypeID] FOREIGN KEY ([ProductTypeID]) REFERENCES [dbo].[tblProductType] ([ProductTypeID])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblProductPlanPeriod].[CreditingRate]
    WITH (LABEL = 'Confidential', LABEL_ID = '331F0B13-76B5-2F1B-A77B-DEF5A73C73C2', INFORMATION_TYPE = 'Credit Card', INFORMATION_TYPE_ID = 'D22FA6E9-5EE4-3BDE-4C2B-A409604C4646', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblProductPlanPeriod_dss_update_trigger] ON [dbo].[tblProductPlanPeriod] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1138103095 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblProductPlanPeriod_dss_tracking] AS [target] 
USING (SELECT [i].[ProductPlanPeriodID] FROM INSERTED AS [i]) AS source([ProductPlanPeriodID]) 
ON ([target].[ProductPlanPeriodID] = [source].[ProductPlanPeriodID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ProductPlanPeriodID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ProductPlanPeriodID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblProductPlanPeriod_dss_insert_trigger] ON [dbo].[tblProductPlanPeriod] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1138103095 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblProductPlanPeriod_dss_tracking] AS [target] 
USING (SELECT [i].[ProductPlanPeriodID] FROM INSERTED AS [i]) AS source([ProductPlanPeriodID]) 
ON ([target].[ProductPlanPeriodID] = [source].[ProductPlanPeriodID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ProductPlanPeriodID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ProductPlanPeriodID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

 
CREATE TRIGGER trg_tblProductPlanPeriodLastModifiedDate
ON [dbo].[tblProductPlanPeriod]
AFTER UPDATE
AS
    UPDATE [dbo].[tblProductPlanPeriod]
    SET [LastModifiedDate] = GETDATE()
    WHERE [ProductPlanPeriodID] IN (SELECT [ProductPlanPeriodID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblProductPlanPeriod_dss_delete_trigger] ON [dbo].[tblProductPlanPeriod] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1138103095 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblProductPlanPeriod_dss_tracking] AS [target] 
USING (SELECT [i].[ProductPlanPeriodID] FROM DELETED AS [i]) AS source([ProductPlanPeriodID]) 
ON ([target].[ProductPlanPeriodID] = [source].[ProductPlanPeriodID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ProductPlanPeriodID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ProductPlanPeriodID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );