CREATE TYPE [TaskHosting].[MessageListType] AS TABLE (
    [MessageId]   UNIQUEIDENTIFIER NOT NULL,
    [JobId]       UNIQUEIDENTIFIER NOT NULL,
    [MessageType] INT              DEFAULT ((0)) NOT NULL,
    [MessageData] NVARCHAR (MAX)   NULL,
    [Version]     BIGINT           DEFAULT ((0)) NOT NULL,
    [TracingId]   UNIQUEIDENTIFIER NULL,
    [QueueId]     UNIQUEIDENTIFIER NULL);

