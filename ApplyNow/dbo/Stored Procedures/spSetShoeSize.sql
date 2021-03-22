
CREATE procedure [dbo].[spSetShoeSize]
(
    @PersonID [int] null,
    @SSNTINTypeID [int] null ,
    @SSNTIN nvarchar(100) null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/7/2020
  Description: Updates a SSN and TIN Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetShoeSize]' 
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
	DECLARE @Need_Update nvarchar(3) = 'No'

	if @PersonID is null 
		set @PersonID = isnull(@PersonID,-99);

	if @SSNTINTypeID is null 
		set @SSNTINTypeID = isnull(@SSNTINTypeID,-99);

	if @SSNTIN is null 
		set @SSNTIN = isnull(@SSNTIN,'');
		
	if @PersonID <> -99
		BEGIN

			set @Record_Exists = isnull((select 'Yes' from [dbo].[tblPerson] with(nolock) where isnull([PersonID],'') = isnull(@PersonID,'')),'No')

			set @Need_Update = isnull((select 'Yes' from [dbo].[tblPerson] with(nolock) where isnull([PersonID],'') = isnull(@PersonID,'')
		                                                                            and isnull([SSNTINTypeID],'') <> -99
																					and isnull(@SSNTINTypeID,'') = -99),'No');

		END

	SET @Parameters = '@PersonID ' + cast(@PersonID as nvarchar) + 
						' @SSNTINTypeID ' + cast(@SSNTINTypeID as nvarchar) + 
						' @SSNTIN ' + cast(@SSNTIN as nvarchar) +
						' @Record_Exists ' + cast(@Record_Exists as nvarchar) 

	if ((@Record_Exists) = 'Yes' and (@Need_Update = 'No'))
		BEGIN
			BEGIN TRY

				update [dbo].[tblPerson]
				set [SSNTINTypeID]	=	@SSNTINTypeID
				   ,[SSNTIN]		=	@SSNTIN
				where PersonID = @PersonID
				and not (isnull([SSNTINTypeID],'')	=	isnull(@SSNTINTypeID,'')
				   and isnull([SSNTIN],'')		=	isnull(@SSNTIN,''))

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

	select @PersonID AS 'PersonID'
	set @Output = '@PersonID ' + cast(@PersonID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END