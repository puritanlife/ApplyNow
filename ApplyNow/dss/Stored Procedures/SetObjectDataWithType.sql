
                    CREATE PROCEDURE [dss].[SetObjectDataWithType]
                        @ObjectId UNIQUEIDENTIFIER,
                        @DataType INT,
                        @ObjectData [varbinary](max),
                        @NoModifySince rowversion = 0xFFFFFFFFFFFFFFFF
                    AS
                    BEGIN
                        IF NOT EXISTS (SELECT * FROM [dss].[SyncObjectData] WHERE [ObjectId] = @ObjectId AND [DataType] = @DataType)
                            INSERT INTO [dss].[SyncObjectData] ([ObjectId], [DataType], [ObjectData])
                                VALUES (@ObjectId, @DataType, @ObjectData);
                        ELSE BEGIN
                            UPDATE [dss].[SyncObjectData] SET [ObjectData] = @ObjectData, [DroppedTime] = NULL
                                WHERE [ObjectId] = @ObjectId AND [DataType] = @DataType AND ([LastModified] <= @NoModifySince OR [DroppedTime] IS NOT NULL)
                        END
                        SELECT [CreatedTime], [LastModified], @@ROWCOUNT AS [Updated] FROM [dss].[SyncObjectData] WHERE [ObjectId] = @ObjectId AND [DataType] = @DataType
                    END