CREATE FUNCTION [dss].[IsSyncGroupActiveOrNotReady]
(
    @SyncGroupId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0

    -- state 0: Active
    -- state 3: NotReady, sync scope info is not provided when creating sync group
    IF EXISTS (SELECT 1 FROM [dss].[syncgroup] WHERE [id] = @SyncGroupId AND [state] IN (0 ,3))
    BEGIN
        SET @Result = 1
    END

    RETURN @Result
END