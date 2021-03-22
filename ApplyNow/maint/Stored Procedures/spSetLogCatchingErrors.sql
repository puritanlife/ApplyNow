
CREATE procedure  [maint].[spSetLogCatchingErrors]
(
    @ErrorNumber nvarchar(255) null,
    @ErrorSeverity nvarchar(255) null,
    @ErrorState nvarchar(255) null,
    @ErrorProcedure nvarchar(255) null,
    @ErrorMessage nvarchar(255) null,
    @ErrorParameters nvarchar(255) null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/7/2020
  Description: Inserts a Log Catching Errors Record.
**************************************************/

	BEGIN

		INSERT INTO [maint].[tblLogCatchingErrors]
			([ErrorNumber]
			,[ErrorSeverity]
			,[ErrorState]
			,[ErrorProcedure]
			,[ErrorMessage]
			,[ErrorParameters])
		SELECT  
			 @ErrorNumber  
			,@ErrorSeverity  
			,@ErrorState  
			,@ErrorProcedure  
			,@ErrorMessage
			,@ErrorParameters;

	END

END