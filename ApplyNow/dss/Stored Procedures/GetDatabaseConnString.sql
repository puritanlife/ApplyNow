CREATE PROCEDURE [dss].[GetDatabaseConnString]
    @DatabaseId	UNIQUEIDENTIFIER,
    @CertificateName NVARCHAR(128),
    @EncryptionKeyName NVARCHAR(128)
AS
BEGIN

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

    SELECT CONVERT(NVARCHAR(MAX), DecryptByKey(connection_string)) AS 'connection_string'
    FROM [dss].[userdatabase]
    WHERE [id] = @DatabaseId

    EXEC('CLOSE SYMMETRIC KEY ' + @EncryptionKeyName)

END