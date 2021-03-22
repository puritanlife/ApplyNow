
CREATE procedure [dbo].[spSetApplyNow]
(
	@ApplyNowID [int] null ,
	@ApplicationID [int] null ,
	@PersonID [int] null ,
	@PersonTypeID [int] null ,
	@Percentage [float] null ,
	@RelationshipTypeID [int] null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 4/21/2020
  Description: Inserts an Apply Now Record.
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetApplyNow]' 
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
	DECLARE @PriorApplyNowID [int] = 0
	DECLARE @PRB_Count [int] = 0
	DECLARE @PRA_Count [int] = 0

	if @ApplyNowID is null 
		set @ApplyNowID = isnull(@ApplyNowID,-99);

	if @ApplicationID is null 
		set @ApplicationID = isnull(@ApplicationID,-99);

	if @PersonID is null 
		set @PersonID = isnull(@PersonID,-99);

	if @PersonTypeID is null 
		set @PersonTypeID = isnull(@PersonTypeID,-99);

	if @Percentage is null 
		set @Percentage = isnull(@Percentage,0.0);

	if @RelationshipTypeID is null 
		set @RelationshipTypeID = isnull(@RelationshipTypeID,99);
		
	if @ApplyNowID <> -99 
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblApplyNow] tblAN with(nolock) where isnull(tblAN.[ApplyNowID],'') = isnull(@ApplyNowID,'')),'No');

    set @PRB_Count = isnull((select count(*) 
	                        from [dbo].[tblApplyNow] tblAN with(nolock) 
							where isnull(tblAN.[ApplicationID],-99) = isnull(@ApplicationID,-99)
							and isnull(tblAN.[PersonID],-99) = isnull(@PersonID,-99)
							and isnull(tblAN.[PersonTypeID],-99) = isnull(@PersonTypeID,-99)),0);
		
	SET @Parameters = '@ApplyNowID ' + cast(@ApplyNowID as nvarchar) + 
					  ' @PR_ApplicationID ' + cast(@ApplicationID as nvarchar) + 
					  ' @PR_PersonID ' + cast(@PersonID as nvarchar) + 
					  ' @PR_PersonTypeID ' + cast(@PersonTypeID as nvarchar) + 
					  ' @Percentage ' + cast(@Percentage as nvarchar) + 
					  ' @RelationshipTypeID ' + cast(@RelationshipTypeID as nvarchar) + 
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar) +
					  ' @PRB_Count ' + cast(@PRB_Count as nvarchar) 

	if @Record_Exists = 'No' and @PRB_Count = 0
		BEGIN

			set @PriorApplyNowID = isnull((select tblAN.ApplyNowID
											from [dbo].[tblApplyNow] tblAN with(nolock) 
											where isnull(tblAN.[PersonTypeID],-99) in (1,4,5,6) -- Annuitant, JointAnnuitant, JointOwner and Owner
											and isnull(tblAN.[ApplicationID],-99) = isnull(@ApplicationID,-99)
											and isnull(tblAN.[PersonTypeID],-99) = isnull(@PersonTypeID,-99)
											and isnull(tblAN.[PersonID],-99) <> isnull(@PersonID,-99)
											and isnull(tblAN.CreatedDate,'') < getdate()),-99) 

			if @PriorApplyNowID <> -99
				BEGIN

					EXEC [dbo].[spRemoveApplyNowPerson] @ApplyNowID = @PriorApplyNowID

				END

			BEGIN
				BEGIN TRY

					INSERT INTO [dbo].[tblApplyNow]
								([ApplicationID]
								,[PersonID]
								,[PersonTypeID]
								,[Percentage]
								,[RelationshipTypeID])
							VALUES
								( @ApplicationID			-- ApplicationID
								, @PersonID				-- PersonID
								, @PersonTypeID			-- PersonTypeID
								, @Percentage			-- Percentage
								, @RelationshipTypeID);	-- RelationshipTypeID

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
			
		END;
	
	if @Record_Exists = 'Yes'
		BEGIN

			Update [dbo].[tblApplyNow]
				set [Percentage] = @Percentage
				   ,[ApplicationID] = @ApplicationID 
				   ,[PersonID] = @PersonID
				   ,[PersonTypeID] = @PersonTypeID
				   ,[RelationshipTypeID] = @RelationshipTypeID
			where [ApplyNowID] = @ApplyNowID;

		END;
	
		set @PRA_Count = isnull((select count(*) 
								from [dbo].[tblApplyNow] tblAN with(nolock) 
								where isnull(tblAN.[ApplicationID],-99) = isnull(@ApplicationID,-99)
								and isnull(tblAN.[PersonID],-99) = isnull(@PersonID,-99)
								and isnull(tblAN.[PersonTypeID],-99) = isnull(@PersonTypeID,-99)),0);

		set @ApplyNowID = (select [ApplyNowID] from [dbo].[tblApplyNow] with(nolock) 
							where isnull([ApplicationID],-99) = isnull(@ApplicationID,-99) 
							and isnull([PersonID],-99) = isnull(@PersonID,-99) 
							and isnull([PersonTypeID],-99) = isnull(@PersonTypeID,-99)
							and isnull([Percentage],0) = isnull(@Percentage,0) 
							and isnull([RelationshipTypeID],-99) = isnull(@RelationshipTypeID,-99));

    if (@PersonTypeID = 6)		-- possible new owner
		BEGIN
			BEGIN TRY

				update [dbo].[tblApplyNow]
				set [PersonID] = @PersonID
				where [RelationshipTypeID] = 54				-- Self
				and [ApplicationID] = @ApplicationID
				and isnull([PersonTypeID],-99) in (1,4,5)	-- Annuitant, JointAnnuitant and JointOwner

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
	
	SET @Parameters = @Parameters + ' @PRA_Count ' + cast(@PRA_Count as nvarchar) 

    select @ApplyNowID AS 'ApplyNowID'
	SET @Output = '@ApplyNowID ' + cast(@ApplyNowID as nvarchar)
	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END