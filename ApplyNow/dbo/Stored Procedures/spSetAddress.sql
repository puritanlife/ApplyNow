
CREATE procedure [dbo].[spSetAddress]
(
    @AddressID [int] null ,
	@PersonID [int] null ,
    @AddressTypeID [int] null ,
    @Address1 nvarchar(max) null ,
    @Address2 nvarchar(max) null ,
    @City nvarchar(max) null ,
    @StateID [int] null ,
    @ZipCode nvarchar(max) null 
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/7/2020
  Description: Inserts an Address record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetAddress]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Record_Exists nvarchar(3) = 'No'

	if @AddressID is null 
		set @AddressID = isnull(@AddressID,-99);

	if @PersonID is null 
		set @PersonID = isnull(@PersonID,-99);

	if @AddressTypeID is null 
		set @AddressTypeID = isnull(@AddressTypeID,-99);

	if @Address1 is null 
		set @Address1 = isnull(@Address1,'');

	if @Address2 is null 
		set @Address2 = isnull(@Address2,'');

	if @City is null 
		set @City = isnull(@City,'');

	if @StateID is null 
		set @StateID = isnull(@StateID,-99);

	if @ZipCode is null 
		set @ZipCode = isnull(@ZipCode,'');
				
	if @AddressTypeID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblAddress] with(nolock) where isnull([AddressID],'') = isnull(@AddressID,'')),'No');

	DECLARE @Parameters nvarchar(max) = '@AddressID ' + cast(@AddressID as nvarchar) + 
	                                    ' @PersonID ' + cast(@PersonID as nvarchar) +
	                                    ' @AddressTypeID ' + cast(@AddressTypeID as nvarchar) +
	                                    ' @Address1 ' + cast(@Address1 as nvarchar) +
	                                    ' @Address2 ' + cast(@Address2 as nvarchar) +
	                                    ' @City ' + cast(@City as nvarchar) +
	                                    ' @StateID ' + cast(@StateID as nvarchar) +
									    ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
				BEGIN TRY

					INSERT INTO [dbo].[tblAddress]
						([PersonID]
						,[AddressTypeID]
						,[Address1]
						,[Address2]
						,[City]
						,[StateID]
						,[ZipCode])
					VALUES
						( @PersonID			-- PersonID
						, @AddressTypeID	-- AddressTypeID
						, @Address1         -- Address1
						, @Address2         -- Address2
						, @City				-- City
						, @StateID			-- StateID
						, @ZipCode);		-- ZipCode

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

				Update [dbo].[tblAddress]
				set [PersonID]		= @PersonID
				,[AddressTypeID]	= @AddressTypeID
				,[Address1]			= @Address1
				,[Address2]			= @Address2
				,[City]				= @City
				,[StateID]			= @StateID
				,[ZipCode]			= @ZipCode
				where AddressID		= @AddressID;	

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
	
	set @AddressID = isnull((select [AddressID] from [dbo].[tblAddress] with(nolock) where isnull([PersonID],'') = isnull(@PersonID,'')
                                                                                     and isnull([AddressTypeID],'') = isnull(@AddressTypeID,'')
                                                                                     and isnull([Address1],'') = isnull(@Address1,'')
                                                                                     and isnull([Address2],'') = isnull(@Address2,'')
                                                                                     and isnull([City],'') = isnull(@City,'')
                                                                                     and isnull([StateID],'') = isnull(@StateID,'')
                                                                                     and isnull([ZipCode],'') = isnull(@ZipCode,'')),0);
	select @AddressID AS 'AddressID'

	set @Output = '@AddressID ' + cast(@AddressID as nvarchar)

	SET @Message = @Message + 'Inserts and updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END