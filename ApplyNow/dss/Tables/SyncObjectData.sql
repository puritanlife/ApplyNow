CREATE TABLE [dss].[SyncObjectData] (
    [ObjectId]     UNIQUEIDENTIFIER NOT NULL,
    [DataType]     INT              NOT NULL,
    [CreatedTime]  DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [DroppedTime]  DATETIME2 (7)    NULL,
    [LastModified] ROWVERSION       NOT NULL,
    [ObjectData]   VARBINARY (MAX)  NOT NULL,
    CONSTRAINT [PK_SyncObjectExtInfo] PRIMARY KEY CLUSTERED ([ObjectId] ASC, [DataType] ASC)
);

