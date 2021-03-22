
CREATE procedure [dbo].[spSetPersonEmail]
(
    @PersonEmailID [int] null,
	@PersonID [int] null ,
    @EmailTypeID [int] null ,
    @EmailAddress nvarchar(max) null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/20/2020
  Description: Inserts a Person Email Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetPersonEmail]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @Record_Exists nvarchar(3) = 'No'

	if @PersonEmailID is null 
		set @PersonEmailID = isnull(@PersonEmailID,-99);

	if @PersonID is null 
		set @PersonID = isnull(@PersonID,'');

	if @EmailTypeID is null 
		set @EmailTypeID = isnull(@EmailTypeID,-99);

	if @EmailAddress is null 
		set @EmailAddress = isnull(@EmailAddress,'');
				
	if @PersonEmailID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblPersonEmail] tblPE with(nolock) where isnull(tblPE.[PersonEmailID],'') = isnull(@PersonEmailID,'')),'No')

	SET @Parameters = '@PersonEmailID ' + cast(@PersonEmailID as nvarchar) + 
	                  ' @PersonID ' + cast(@PersonID as nvarchar) + 
					  ' @EmailTypeID ' + cast(@EmailTypeID as nvarchar) +
					  ' @EmailAddress ' + cast(@EmailAddress as nvarchar) +
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblPersonEmail]
						   ([PersonID]
						   ,[EmailTypeID]
						   ,[EmailAddress])
					 VALUES
						   (@PersonID		-- PersonID
						   ,@EmailTypeID	-- EmailTypeID
						   ,@EmailAddress)	-- EmailAddress

			END TRY
			BEGIN CATCH  

				SELECT  
					@ErrorNumber = ERROR_NUMBER()
				,@ErrorSeverity = ERROR_SEVERITY()
				,@ErrorState = ERROR_STATE()
				,@ErrorProcedure = ERROR_PROCEDURE()
				,@ErrorMessage = ERROR_MESSAGE();

				EXEC [maint].[spSetLogCatchingErrors]
				@ErrorNumber = @ErrorNumber,
				@ErrorSeverity = @ErrorSeverity,
				@ErrorState = @ErrorState,
				@ErrorProcedure = @Procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorParameters = @Parameters

			END CATCH;  

		END;

	if @Record_Exists = 'Yes'
		BEGIN
			BEGIN TRY

				update [dbo].[tblPersonEmail]
				set [PersonID] = @PersonID
				 , [EmailTypeID] = @EmailTypeID
				 , [EmailAddress] = @EmailAddress
				where [PersonEmailID] = @PersonEmailID

			END TRY
			BEGIN CATCH  

				SELECT  
					@ErrorNumber = ERROR_NUMBER()
				,@ErrorSeverity = ERROR_SEVERITY()
				,@ErrorState = ERROR_STATE()
				,@ErrorProcedure = ERROR_PROCEDURE()
				,@ErrorMessage = ERROR_MESSAGE();

				EXEC [maint].[spSetLogCatchingErrors]
				@ErrorNumber = @ErrorNumber,
				@ErrorSeverity = @ErrorSeverity,
				@ErrorState = @ErrorState,
				@ErrorProcedure = @Procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorParameters = @Parameters

			END CATCH;  

		END;

	set @PersonEmailID = (select [PersonEmailID] from [dbo].[tblPersonEmail] tblPE with(nolock) where isnull(PersonID,'') = isnull(@PersonID,'') and isnull(EmailTypeID,'') = isnull(@EmailTypeID,''))
	
	select @PersonEmailID AS 'PersonEmailID'
	SET @Output = '@PersonEmailID '+cast(@PersonEmailID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END