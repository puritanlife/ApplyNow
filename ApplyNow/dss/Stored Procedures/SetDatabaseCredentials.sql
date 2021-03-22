CREATE PROCEDURE [dss].[SetDatabaseCredentials]
    @DatabaseID	UNIQUEIDENTIFIER,
    @ConnectionString NVARCHAR(MAX),
    @CertificateName NVARCHAR(128),
    @EncryptionKeyName NVARCHAR(128)
AS
BEGIN
    DECLARE @State INT
    SET @State = (SELECT [state] FROM [dss].[userdatabase] WHERE [id] = @DatabaseID)

    IF NOT EXISTS
        (SELECT * FROM sys.certificates WHERE name = @CertificateName)
    BEGIN
        RAISERROR('CERTIFICATE_NOT_EXIST', 16, 1)
        RETURN
    END

    IF NOT EXISTS
        (SELECT * FROM sys.symmetric_keys WHERE name = @EncryptionKeyName)
    BEGIN
        RAISERROR('ENCRYPTION_KEY_NOT_EXIST', 16, 1)
        RETURN
    END

    EXEC('OPEN SYMMETRIC KEY '+ @EncryptionKeyName + ' DECRYPTION BY CERTIFICATE ' + @CertificateName)

    UPDATE [dss].[userdatabase]
    SET
        [connection_string] =  EncryptByKey(Key_GUID(@EncryptionKeyName), @ConnectionString)
    WHERE [id] = @DatabaseID

    EXEC('CLOSE SYMMETRIC KEY ' + @EncryptionKeyName)

    IF (@State = 5) -- 5:SuspendedDueToWrongCredentials
    BEGIN
        UPDATE [dss].[userdatabase]
        SET [state] = 0 -- 0:active
        WHERE [id] = @DatabaseID
    END
END