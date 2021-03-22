CREATE TABLE [TaskHosting].[Schedule] (
    [ScheduleId]   INT IDENTITY (1, 1) NOT NULL,
    [FreqType]     INT NOT NULL,
    [FreqInterval] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([ScheduleId] ASC)
);

