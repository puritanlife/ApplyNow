CREATE PROCEDURE [dss].[DeleteSubscription]
    @SubscriptionID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        -- Remove agent instances
        DELETE FROM [dss].[agent_instance]
        WHERE [agentid] IN (SELECT [id] FROM [dss].[agent] WHERE [subscriptionid] = @SubscriptionID)

        -- delete the userdatabase records
        -- this will raise and error if any of them are referenced by a syncgroup
        DELETE FROM [dss].[userdatabase] WHERE [subscriptionid] = @SubscriptionID

        -- Remove agents
        DELETE FROM [dss].[agent]
        WHERE [subscriptionid] = @SubscriptionID

        -- Delete subscription
        DELETE FROM [dss].[subscription] WHERE [id] = @SubscriptionID

        IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        IF (ERROR_NUMBER() = 547) -- FK/constraint violation
        BEGIN
            -- some dependant tables are not cleaned up yet.
            RAISERROR('SERVER_DELETE_CONSTRAINT_VIOLATION',15, 1)
        END
        ELSE
        BEGIN
             -- get error infromation and raise error
            EXECUTE [dss].[RethrowError]
        END

        RETURN

    END CATCH

END