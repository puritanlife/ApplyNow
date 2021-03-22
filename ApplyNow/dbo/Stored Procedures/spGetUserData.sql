

CREATE procedure [dbo].[spGetUserData]
(
	@UserID int = NULL
) AS
BEGIN
	/*************************************************
	 Author:      Daniel Kelleher
	 Create Date: 4/21/2020
	 Description: Obtains user information.
	*************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetUserData]' 
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
	DECLARE @Parameters nvarchar(max) = null

	SET @Parameters = '@UserID ' + cast(@UserID as nvarchar) 

	SELECT 
	ut.[Type]
	, u.[Email]
	, u.[Pass]
	, u.[Attempt]
	, u.[locked]
	, u.[Last_Login]
	, u.[IsAdmin]
	, u.[PasswordChangeDate]
	, u.[Question1]
	, u.[Question1ChangeDate]
	, u.[Answer1]
	, u.[Answer1ChangeDate]
	, u.[Question2]
	, u.[Question2ChangeDate]
	, u.[Answer2]
	, u.[Answer2ChangeDate]
	, u.[Question3]
	, u.[Question3ChangeDate]
	, u.[Answer3]
	, u.[Answer3ChangeDate]
	FROM [dbo].[tblUser] AS u with(nolock)
	left outer join [dbo].[tblUserType] ut with(nolock) on ut.[UserTypeID] = u.[UserTypeID]
	WHERE u.[UserID] = ISNULL(@UserID, u.[UserID])
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