CREATE PROCEDURE [dss].[GetSyncGroupMembersForGroup]
    @SyncGroupID UNIQUEIDENTIFIER,
    @NeedUpdateLock	BIT
AS
BEGIN
    IF (@NeedUpdateLock = 1)
    BEGIN
        SELECT
            [id],
            [name],
            [scopename],
            [syncgroupid],
            [syncdirection],
            [databaseid],
            [memberstate],
            [hubstate],
            [memberstate_lastupdated],
            [hubstate_lastupdated],
            [lastsynctime],
            [lastsynctime_zerofailures_member],
            [lastsynctime_zerofailures_hub],
            [jobId],
            [noinitsync],
            [memberhasdata]
            -- This method is called from the ActionApi so
            -- we will lock the syncgroupmember rows in the database,
            -- so that we don't end up creating more than 1 sync task per member.
        FROM [dss].[syncgroupmember] WITH (UPDLOCK)
        WHERE [syncgroupid] = @SyncGroupID
    END
    ELSE
    BEGIN
        SELECT
            [id],
            [name],
            [scopename],
            [syncgroupid],
            [syncdirection],
            [databaseid],
            [memberstate],
            [hubstate],
            [memberstate_lastupdated],
            [hubstate_lastupdated],
            [lastsynctime],
            [lastsynctime_zerofailures_member],
            [lastsynctime_zerofailures_hub],
            [JobId],
            [noinitsync],
            [memberhasdata]
            -- This method is called from the ActionApi so
            -- we will lock the syncgroupmember rows in the database,
            -- so that we don't end up creating more than 1 sync task per member.
        FROM [dss].[syncgroupmember]
        WHERE [syncgroupid] = @SyncGroupID
    END
END