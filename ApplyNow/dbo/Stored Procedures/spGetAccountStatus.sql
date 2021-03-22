
CREATE procedure [dbo].[spGetAccountStatus]
(
	@Email varchar(75) = NULL
) AS
BEGIN
/*************************************************
	Author:      Daniel Kelleher
	Create Date: 4/20/2020
	Description: Returns an integer that represents the status of an user account.
	            For every time this procedure is called, the [spSetLoginAttempt] 
				procedure is called to insert the Login Attempt 
				([dbo].[tblLogin_Attempt]) result by capturing attempt flag/ 
				message.
				0 = Account found & not locked UserID and Password are returned.
	            1 = Account found & locked UserID is returned.
	            2 = Account not found
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetAccountStatus]' 
	DECLARE @Error nvarchar(max) = null 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 
	DECLARE @SP_RowCount int = null

	-- Declaring variables for stored procedure's execution
	DECLARE @count int
	SET @count = (SELECT COUNT(*) FROM dbo.tblUSER u with(nolock) WHERE u.Email = @Email)

	DECLARE @Parameters nvarchar(max) = '@Email ' + cast(@Email as nvarchar) + ' @count ' + cast(@count as nvarchar)

    SELECT
		(CASE WHEN @count > 0 THEN
			(SELECT u.locked FROM dbo.tblUSER u with(nolock) WHERE u.Email = @Email) 
			ELSE 2 END)		                                                            AS [AccountStatus],
		(SELECT u.UserId FROM dbo.tblUSER u with(nolock) WHERE u.Email = @Email)		AS [UserID],
		(SELECT u.Pass FROM dbo.tblUSER u with(nolock) WHERE u.Email = @Email)			AS [Password],
		(SELECT u.[UserTypeID] FROM dbo.tblUSER u with(nolock) WHERE u.Email = @Email)	AS [UserTypeID]
    SET @SP_RowCount = @@ROWCOUNT;

    EXEC [dbo].[spSetLoginAttempt] @Email

	SET @Message = @Message + 'Select only, not inserts or updates. '
	SET @Output = @Output + 'Record Count ' + cast(@SP_RowCount as varchar)

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END