
                    CREATE PROCEDURE [dss].[RemoveObjectData]
                        @ObjectId UNIQUEIDENTIFIER,
                        @DataType     INT = null,
                        @RemoveRecord BIT = 0
                    AS
                    BEGIN
                        IF @RemoveRecord = 0
                            UPDATE [dss].[SyncObjectData] SET [DroppedTime] = GETUTCDATE()
                                WHERE [ObjectId] = @ObjectId AND (@DataType IS NULL OR [DataType] = @DataType);
                        ELSE
                            DELETE FROM [dss].[SyncObjectData]
                                WHERE [ObjectId] = @ObjectId AND (@DataType IS NULL OR [DataType] = @DataType);
                    END