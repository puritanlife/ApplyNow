CREATE PROCEDURE [dss].[GetConfigurationValue]
    @ConfigKey NVARCHAR(100)
AS
BEGIN
    DECLARE @ConfigValue NVARCHAR(256)

    SELECT [ConfigValue] FROM [dss].[configuration] WHERE [ConfigKey] = @ConfigKey
END