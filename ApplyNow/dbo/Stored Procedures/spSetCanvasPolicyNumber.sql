
CREATE procedure [dbo].[spSetCanvasPolicyNumber]
(
    @ApplicationID [int] null 
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/3/2020
  Description: Updates Canvas Policy Number within Application Record.
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetCanvasPolicyNumber]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null

	DECLARE @PolicyNumber [int] = 0
	DECLARE @CanvasPolicyNumber nvarchar(100) = ''
	DECLARE @Record_Exists nvarchar(3) = 'No'
	DECLARE @StateLicenseTypeID [int] = 0

	if @ApplicationID is null 
		set @ApplicationID		= isnull(@ApplicationID,-99);

	if @ApplicationID <> -99
		set @Record_Exists		= isnull((select 'Yes' from [dbo].[tblApplication] with(nolock) where isnull([ApplicationID],'') = isnull(@ApplicationID,'')),'No');

	SET @Parameters = '@ApplicationID ' + cast(@ApplicationID as nvarchar) + 
	                  ' @Record_Exists ' + cast(@Record_Exists as nvarchar) 

	if @Record_Exists = 'Yes'
	BEGIN

	    set @CanvasPolicyNumber = isnull((select [CanvasPolicyNumber] from [dbo].[tblApplication] with(nolock) where [ApplicationID] = isnull(@ApplicationID,0)),'');
		
		if @CanvasPolicyNumber = ''
			begin
				set @PolicyNumber = (select isnull(max([dbo].[udf_GetNumeric](tblA.[CanvasPolicyNumber])),0) + 1 from [dbo].[tblApplication] tblA with(nolock));
				set @PolicyNumber = (case when @PolicyNumber < 10000 then 10000 else 0 end) + @PolicyNumber
				set @CanvasPolicyNumber = 'C'+right('0000000'+cast(@PolicyNumber as varchar),7);
			end

		BEGIN TRY

			update [dbo].[tblApplication]
				set [CanvasPolicyNumber] = @CanvasPolicyNumber 
			where ApplicationID			  = @ApplicationID
			and isnull([CanvasPolicyNumber],'') = '';

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
	
	select @ApplicationID = [ApplicationID], @CanvasPolicyNumber = isnull([CanvasPolicyNumber],'No Policy Number Yet') from [dbo].[tblApplication] with(nolock) where [ApplicationID] = @ApplicationID;
	select [ApplicationID] AS [ApplicationID], isnull([CanvasPolicyNumber],'No Policy Number Yet') as [CanvasPolicyNumber] from [dbo].[tblApplication] with(nolock) where [ApplicationID] = @ApplicationID;
	
	set @Output = '@ApplicationID '+ cast(@ApplicationID as nvarchar) + ' @CanvasPolicyNumber '+ cast(@CanvasPolicyNumber as nvarchar) 

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END