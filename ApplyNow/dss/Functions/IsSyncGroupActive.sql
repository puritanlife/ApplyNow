CREATE FUNCTION [dss].[IsSyncGroupActive]
(
    @SyncGroupId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0

    IF EXISTS (SELECT 1 FROM [dss].[syncgroup] WHERE [id] = @SyncGroupId AND [state] = 0)
    BEGIN
        SET @Result = 1
    END

    RETURN @Result
END