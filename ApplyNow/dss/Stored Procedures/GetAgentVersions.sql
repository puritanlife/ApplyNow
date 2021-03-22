CREATE PROCEDURE [dss].[GetAgentVersions]
    AS
BEGIN
    SELECT
        [Id],
        [Version],
        [ExpiresOn],
        [Comment]

    FROM [dss].[agent_version]
END