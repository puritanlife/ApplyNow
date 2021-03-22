
                    CREATE PROCEDURE [dss].[GetObjectDataWithType]
                        @ObjectId UNIQUEIDENTIFIER,
                        @DataType INT
                    AS
                    BEGIN
                        SELECT [ObjectId]
                            ,[CreatedTime]
                            ,[DroppedTime]
                            ,[LastModified]
                            ,[ObjectData]
                        FROM [dss].[SyncObjectData]
                        WHERE [ObjectId] = @ObjectId AND [DataType] = @DataType AND [DroppedTime] IS NULL
                    END