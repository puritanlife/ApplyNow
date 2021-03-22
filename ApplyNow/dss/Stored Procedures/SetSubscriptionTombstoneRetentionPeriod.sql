CREATE PROCEDURE [dss].[SetSubscriptionTombstoneRetentionPeriod]
    @SubscriptionId uniqueidentifier,
    @RetentionPeriodInDays int
AS
    UPDATE [dss].[subscription]
    SET
        [tombstoneretentionperiodindays] = @RetentionPeriodInDays
    WHERE
        [id] = @SubscriptionId

RETURN @@ROWCOUNT