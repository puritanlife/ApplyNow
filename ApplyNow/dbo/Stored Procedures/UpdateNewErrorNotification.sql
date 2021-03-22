CREATE PROC dbo.UpdateNewErrorNotification @NewErrorID INT
AS

BEGIN
 UPDATE dbo.tblNewErrorNotification
 SET IsEmailSent = 1
 WHERE NewErrorID = @NewErrorID

END