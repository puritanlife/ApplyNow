CREATE TABLE [dss].[taskdependency] (
    [nexttaskid] UNIQUEIDENTIFIER NOT NULL,
    [prevtaskid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_TaskTask] PRIMARY KEY CLUSTERED ([nexttaskid] ASC, [prevtaskid] ASC),
    CONSTRAINT [FK__taskdepen__nextt] FOREIGN KEY ([nexttaskid]) REFERENCES [dss].[task] ([id]),
    CONSTRAINT [FK__taskdepen__prevt] FOREIGN KEY ([prevtaskid]) REFERENCES [dss].[task] ([id])
);

