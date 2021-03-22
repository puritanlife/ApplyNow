
CREATE procedure [dbo].[spSetPersonPhone]
(
    @PersonPhoneID [int] null,
	@PersonID [int] null ,
    @PhoneTypeID [int] null ,
    @PhoneNumber nvarchar(max) null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/20/2020
  Description: Inserts a Person Phone Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetPersonPhone]' 
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

	if @PersonPhoneID is null 
		set @PersonPhoneID = isnull(@PersonPhoneID,-99);

	if @PersonID is null 
		set @PersonID = isnull(@PersonID,'');

	if @PhoneTypeID is null 
		set @PhoneTypeID = isnull(@PhoneTypeID,-99);

	if @PhoneNumber is null 
		set @PhoneNumber = isnull(@PhoneNumber,'');
				
	if @PersonPhoneID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblPersonPhone] with(nolock) where isnull([PersonPhoneID],'') = isnull(@PersonPhoneID,'')),'No')
		
	SET @Parameters = '@PersonPhoneID ' + cast(@PersonPhoneID as nvarchar) + 
	                  ' @PersonID ' + cast(@PersonID as nvarchar) + 
	                  ' @PhoneTypeID ' + cast(@PhoneTypeID as nvarchar) + 
					  ' @PhoneNumber ' + cast(@PhoneNumber as nvarchar) +
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar) 

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblPersonPhone]
						   ([PersonID]
						   ,[PhoneTypeID]
						   ,[PhoneNumber])
					 VALUES
						   (@PersonID		-- PersonID
						   ,@PhoneTypeID	-- PhoneTypeID
						   ,@PhoneNumber)	-- PhoneNumber

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

				update [dbo].[tblPersonPhone]
				set [PersonID] = @PersonID 
				, [PhoneTypeID] = @PhoneTypeID
				, [PhoneNumber] = @PhoneNumber
				where [PersonPhoneID] = @PersonPhoneID 

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

	set @PersonPhoneID = (select [PersonPhoneID] from [dbo].[tblPersonPhone] with(nolock) where isnull([PersonID],'') = isnull(@PersonID,'') 
		                                                                                    and isnull([PhoneTypeID],'') = isnull(@PhoneTypeID,'')
																							and isnull([PhoneNumber],'') = isnull(@PhoneNumber,''))

	select @PersonPhoneID AS 'PersonPhoneID'
	set @Output = '@PersonPhoneID '+cast(@PersonPhoneID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END