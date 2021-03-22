




CREATE procedure [dbo].[spSetPerson]
(
    @PersonID [int] null,
    @UUID nvarchar(250) null,
    @BusinessName nvarchar(255) null,
    @FirstName nvarchar(255) null,
    @MiddleName nvarchar(255) null,
    @LastName nvarchar(255) null,
    @DOB [date] null ,
    @ResidentAlien [bit] null ,
    @USCitizen [bit] null ,
    @GenderTypeID [int] null ,
    --@SSNTINTypeID [int] null ,
    @BirthStateID [int] null ,
    @IDNumber nvarchar(100) null --,
    --@SSNTIN nvarchar(100) null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/7/2020
  Description: Inserts a Person Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetPerson]' 
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
	DECLARE @SSNTINTypeID [int] = -99 
	DECLARE @SSNTIN nvarchar(100) = null 

	if @PersonID is null 
		set @PersonID = isnull(@PersonID,-99);

	if @UUID is null 
		set @UUID = isnull(@UUID,'');

	if @BusinessName is null 
		set @BusinessName = isnull(@BusinessName,'');

	if @FirstName is null 
		set @FirstName = isnull(@FirstName,'');

	if @MiddleName is null 
		set @MiddleName = isnull(@MiddleName,'');

	if @LastName is null 
		set @LastName = isnull(@LastName,'');

	if @DOB is null 
		set @DOB = isnull(@DOB,'1900-01-01');

	if @ResidentAlien is null 
		set @ResidentAlien = isnull(@ResidentAlien,0);

	if @USCitizen is null 
		set @USCitizen = isnull(@USCitizen,0);

	if @GenderTypeID is null 
		set @GenderTypeID = isnull(@GenderTypeID,-99);

	if @SSNTINTypeID is null 
		set @SSNTINTypeID = isnull(@SSNTINTypeID,-99);

	if @BirthStateID is null 
		set @BirthStateID = isnull(@BirthStateID,-99);

	if @IDNumber is null 
		set @IDNumber = isnull(@IDNumber,'');

	if @SSNTIN is null 
		set @SSNTIN = isnull(@SSNTIN,'');
	
	if @PersonID <> -99
	    set @Record_Exists = isnull((select distinct 'Yes' from [dbo].[tblPerson] with(nolock) where isnull([PersonID],'') <> -99 and isnull([PersonID],'') = isnull(@PersonID,'') ),'No')
		--set @Record_Exists = isnull((select distinct 'Yes' from [dbo].[tblPerson] with(nolock) where isnull([PersonID],'') <> -99 and isnull([PersonID],'') = isnull(@PersonID,'')or isnull([UUID],'') = isnull(@UUID,'') ),'No') -- john added 9-8-2020
 

	SET @Parameters = '@PersonID ' + cast(@PersonID as nvarchar) + 
	                  ' @UUID ' + cast(@UUID as nvarchar(100)) + 
	                  ' @BusinessName ' + cast(@BusinessName as nvarchar) + 
	                  ' @FirstName ' + cast(@FirstName as nvarchar) + 
                      ' @MiddleName ' + cast(@MiddleName as nvarchar) + 
	                  ' @LastName ' + cast(@LastName as nvarchar) + 
	                  ' @DOB ' + cast(@DOB as nvarchar) + 
	                  ' @ResidentAlien ' + cast(@ResidentAlien as nvarchar) + 
	                  ' @USCitizen ' + cast(@USCitizen as nvarchar) + 
	                  ' @GenderTypeID ' + cast(@GenderTypeID as nvarchar) + 
	                  ' @BirthStateID ' + cast(@BirthStateID as nvarchar) + 
	                  ' @IDNumber ' + cast(@IDNumber as nvarchar) + 	                  
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblPerson]
					([UUID]
					,[BusinessName]
					,[FirstName]
					,[MiddleName]
					,[LastName]
					,[DOB]
					,[ResidentAlien]
					,[USCitizen]
					,[GenderTypeID]
					,[SSNTINTypeID]
					,[BirthStateID]
					,[IDNumber]
					,[SSNTIN])
				VALUES
					( @UUID             -- UUID
					, @BusinessName		-- BusinessName	
					, @FirstName		-- FirstName
					, @MiddleName		-- MiddleName
					, @LastName			-- LastName
					, @DOB				-- DOB
					, @ResidentAlien	-- ResidentAlien
					, @USCitizen		-- USCitizen
					, @GenderTypeID		-- GenderTypeID
					, @SSNTINTypeID		-- SSNTINTypeID
					, @BirthStateID		-- BirthStateID
					, @IDNumber			-- IDNumber
					, @SSNTIN );		-- SSNTIN

						--Set @PersonID = @@IDENTITY
						Set @PersonID =(select tblP.[PersonID] from [dbo].[tblPerson] tblP with(nolock)  -- john added 9-8-2020
		                                    where isnull(tblP.[BusinessName],'') = isnull(@BusinessName,'') -- john added 9-8-2020
                                            and isnull(tblP.[FirstName],'') = isnull(@FirstName,'') -- john added 9-8-2020
                                            and isnull(tblP.[MiddleName],'') = isnull(@MiddleName,'') -- john added 9-8-2020
                                            and isnull(tblP.[LastName],'') = isnull(@LastName,'') -- john added 9-8-2020
                                            and isnull(tblP.[DOB],'') = isnull(@DOB,'') -- john added 9-8-2020
                                            and isnull(tblP.[ResidentAlien],0) = isnull(@ResidentAlien,0) -- john added 9-8-2020
                                            and isnull(tblP.[USCitizen],0) = isnull(@USCitizen,0) -- john added 9-8-2020
                                            and isnull(tblP.[GenderTypeID],-99) = isnull(@GenderTypeID,-99) -- john added 9-8-2020
                                            and isnull(tblP.[BirthStateID],-99) = isnull(@BirthStateID,-99) -- john added 9-8-2020
                                            and isnull(tblP.[IDNumber],'') = isnull(@IDNumber,'') -- john added 9-8-2020
											and isnull(tblP.[UUID],'') = isnull(@UUID,'')			 -- john added 9-8-2020		
											--and isnull(tblP.[PersonID],'') = isnull(@@IDENTITY,'')
											and ISNULL(tblP.CreatedDate,'') = (select MAX(stblP.CreatedDate) from [dbo].[tblPerson] stblP where isnull(stblP.[PersonID],'') = isnull(@@IDENTITY,''))
											)




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

				update [dbo].[tblPerson]
				set [BusinessName]	=	@BusinessName
				   ,[FirstName]		=	@FirstName
				   ,[MiddleName]	=	@MiddleName
				   ,[LastName]		=	@LastName
				   ,[DOB]			=	@DOB
				   ,[ResidentAlien]	=	@ResidentAlien
				   ,[USCitizen]		=	@USCitizen
				   ,[GenderTypeID]	=	@GenderTypeID
				   --,[SSNTINTypeID]	=	@SSNTINTypeID
				   ,[BirthStateID]	=	@BirthStateID
				   ,[IDNumber]		=	@IDNumber
				   --,[SSNTIN]		=	@SSNTIN
				where PersonID = @PersonID;

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

	--Set @PersonID = (select tblP.[PersonID] from [dbo].[tblPerson] tblP with(nolock) 
	--	                                    where isnull(tblP.[BusinessName],'') = isnull(@BusinessName,'')
 --                                           and isnull(tblP.[FirstName],'') = isnull(@FirstName,'')
 --                                           and isnull(tblP.[MiddleName],'') = isnull(@MiddleName,'')
 --                                           and isnull(tblP.[LastName],'') = isnull(@LastName,'')
 --                                           and isnull(tblP.[DOB],'') = isnull(@DOB,'')
 --                                           and isnull(tblP.[ResidentAlien],0) = isnull(@ResidentAlien,0)
 --                                           and isnull(tblP.[USCitizen],0) = isnull(@USCitizen,0)
 --                                           and isnull(tblP.[GenderTypeID],-99) = isnull(@GenderTypeID,-99)
 --                                           and isnull(tblP.[BirthStateID],-99) = isnull(@BirthStateID,-99)
 --                                           and isnull(tblP.[IDNumber],'') = isnull(@IDNumber,''))

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