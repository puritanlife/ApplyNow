CREATE TABLE [TaskHosting].[ScheduleTask] (
    [ScheduleTaskId] UNIQUEIDENTIFIER NOT NULL,
    [TaskType]       INT              NOT NULL,
    [TaskName]       NVARCHAR (128)   NOT NULL,
    [Schedule]       INT              NULL,
    [State]          INT              NOT NULL,
    [NextRunTime]    DATETIME         NOT NULL,
    [MessageId]      UNIQUEIDENTIFIER NULL,
    [TaskInput]      NVARCHAR (MAX)   NULL,
    [QueueId]        UNIQUEIDENTIFIER NOT NULL,
    [TracingId]      UNIQUEIDENTIFIER NOT NULL,
    [JobId]          UNIQUEIDENTIFIER DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    PRIMARY KEY CLUSTERED ([ScheduleTaskId] ASC),
    FOREIGN KEY ([Schedule]) REFERENCES [TaskHosting].[Schedule] ([ScheduleId])
);


GO
CREATE NONCLUSTERED INDEX [ScheduleTask_MessageId_Index]
    ON [TaskHosting].[ScheduleTask]([MessageId] ASC);

