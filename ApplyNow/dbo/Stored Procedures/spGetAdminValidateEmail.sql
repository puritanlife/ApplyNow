
CREATE procedure [dbo].[spGetAdminValidateEmail]
(
	@AdminEmail varchar(75) = NULL
) AS
BEGIN
/*************************************************
	Author:      Daniel Kelleher
	Create Date: 4/21/2020
	Description: Returns a code that represents the Admin Password, AdminID, Locked and Status of an Account:
				0 = Email not Exists
				1 = Email Exists
*************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetAdminValidateEmail]' 
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
	DECLARE @Parameters nvarchar(max) = '@AdminEmail ' + cast(@AdminEmail as nvarchar) 

	SELECT
		isnull((SELECT COUNT(*) FROM dbo.tblAdminUser au with(nolock) WHERE au.Email = @AdminEmail),0) AS [EmailStatus] ,
		(SELECT au.Pass FROM dbo.tblAdminUser au with(nolock) WHERE au.Email = @AdminEmail) AS [Password] ,
        (SELECT au.AdminUserId FROM dbo.tblAdminUser au with(nolock) WHERE au.Email = @AdminEmail) AS [AdminID] ,
		(SELECT au.Locked FROM dbo.tblAdminUser au with(nolock) WHERE au.Email = @AdminEmail) AS [Locked]
	SET @SP_RowCount = @@ROWCOUNT;

	SET @Message = @Message + 'Select only, not inserts or updates. '
	SET @Output = @Output + 'Record Count ' + cast(@SP_RowCount as varchar)

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall
		
END