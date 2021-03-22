CREATE PROCEDURE [dss].[UpdateSyncMemberHasData]
    @syncMemberid uniqueidentifier,
    @hasData bit
AS
BEGIN
    UPDATE [dss].[syncgroupmember]
    SET
        [memberhasdata] = @hasData
    WHERE [id] = @syncMemberid
END