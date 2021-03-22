CREATE PROCEDURE [dss].[CreateAgent]
    @AgentID	UNIQUEIDENTIFIER,
    @Name	[dss].[DISPLAY_NAME],
    @SubscriptionID	UNIQUEIDENTIFIER,
    @IsOnPremise	BIT,
    @Version	[dss].[VERSION]
AS
BEGIN

    BEGIN TRY
        INSERT INTO
        [dss].[agent]
        (
            [id],
            [name],
            [subscriptionid],
            [state],
            [lastalivetime],
            [is_on_premise],
            [version],
            [password_hash],
            [password_salt]
        )
        VALUES
        (
            @AgentID,
            @Name,
            @SubscriptionID,
            1, -- 1: active
            NULL,
            @IsOnPremise,
            @Version,
            NULL,
            NULL
        )

    END TRY
    BEGIN CATCH
         IF (ERROR_NUMBER() = 2601) -- Index violation
         BEGIN
            RAISERROR('DUPLICATE_AGENTNAME',15, 1)
         END
         ELSE
         BEGIN
             -- get error infromation and raise error
            EXECUTE [dss].[RethrowError]
            END

        RETURN
    END CATCH

END