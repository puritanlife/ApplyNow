CREATE TABLE [dss].[ScheduleTask] (
    [Id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [SyncGroupId]    UNIQUEIDENTIFIER NOT NULL,
    [Interval]       BIGINT           NOT NULL,
    [LastUpdate]     DATETIME         NOT NULL,
    [State]          TINYINT          DEFAULT ((0)) NOT NULL,
    [ExpirationTime] DATETIME         NULL,
    [PopReceipt]     UNIQUEIDENTIFIER NULL,
    [DequeueCount]   TINYINT          DEFAULT ((0)) NOT NULL,
    [Type]           INT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ScheduleTask] PRIMARY KEY CLUSTERED ([SyncGroupId] ASC),
    CONSTRAINT [FK__ScheduleT__SyncG] FOREIGN KEY ([SyncGroupId]) REFERENCES [dss].[syncgroup] ([id])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dss].[ScheduleTask].[ExpirationTime]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credit Card', INFORMATION_TYPE_ID = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646', RANK = MEDIUM);

