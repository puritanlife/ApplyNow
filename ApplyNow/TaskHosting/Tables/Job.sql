CREATE TABLE [TaskHosting].[Job] (
    [JobId]                UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [IsCancelled]          BIT              DEFAULT ((0)) NOT NULL,
    [InitialInsertTimeUTC] DATETIME         DEFAULT (getutcdate()) NOT NULL,
    [JobType]              INT              DEFAULT ((0)) NOT NULL,
    [InputData]            NVARCHAR (MAX)   NULL,
    [TaskCount]            INT              DEFAULT ((0)) NOT NULL,
    [CompletedTaskCount]   INT              DEFAULT ((0)) NOT NULL,
    [TracingId]            UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([JobId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_job_iscancelled]
    ON [TaskHosting].[Job]([IsCancelled] ASC);

