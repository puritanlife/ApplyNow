CREATE TABLE [TaskHosting].[MessageQueue] (
    [MessageId]            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [JobId]                UNIQUEIDENTIFIER NULL,
    [MessageType]          INT              DEFAULT ((0)) NOT NULL,
    [MessageData]          NVARCHAR (MAX)   NULL,
    [InitialInsertTimeUTC] DATETIME         DEFAULT (getutcdate()) NOT NULL,
    [InsertTimeUTC]        DATETIME         NOT NULL,
    [UpdateTimeUTC]        DATETIME         NULL,
    [ExecTimes]            TINYINT          DEFAULT ((0)) NOT NULL,
    [ResetTimes]           INT              DEFAULT ((0)) NOT NULL,
    [Version]              BIGINT           DEFAULT ((0)) NOT NULL,
    [TracingId]            UNIQUEIDENTIFIER NULL,
    [QueueId]              UNIQUEIDENTIFIER NULL,
    [WorkerId]             UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([MessageId] ASC),
    CONSTRAINT [Chk_ExecTimes_GreaterOrEqualZero] CHECK ([ExecTimes]>=(0)),
    FOREIGN KEY ([JobId]) REFERENCES [TaskHosting].[Job] ([JobId])
);


GO
CREATE NONCLUSTERED INDEX [index_messagequeue_getnextmessagebytype]
    ON [TaskHosting].[MessageQueue]([QueueId] ASC, [MessageType] ASC, [UpdateTimeUTC] ASC, [InsertTimeUTC] ASC, [ExecTimes] ASC, [Version] ASC);


GO
CREATE NONCLUSTERED INDEX [index_messagequeue_getnextmessage]
    ON [TaskHosting].[MessageQueue]([QueueId] ASC, [UpdateTimeUTC] ASC, [InsertTimeUTC] ASC, [ExecTimes] ASC, [Version] ASC);


GO
CREATE NONCLUSTERED INDEX [index_messagequeue_jobid]
    ON [TaskHosting].[MessageQueue]([JobId] ASC);

