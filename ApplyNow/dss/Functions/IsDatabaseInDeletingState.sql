CREATE FUNCTION [dss].[IsDatabaseInDeletingState]
(
    @DatabaseId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0

    IF EXISTS (SELECT 1 FROM [dss].[userdatabase] WHERE [id] = @DatabaseId AND [state] = 1)
    BEGIN
        SET @Result = 1
    END

    RETURN @Result
END