CREATE TYPE [dss].[TaskDependencyTableType] AS TABLE (
    [nexttaskid] UNIQUEIDENTIFIER NULL,
    [prevtaskid] UNIQUEIDENTIFIER NULL);

