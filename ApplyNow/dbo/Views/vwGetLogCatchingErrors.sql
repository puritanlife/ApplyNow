
CREATE VIEW [dbo].[vwGetLogCatchingErrors]
AS
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 4/21/2020
  Description: Gets all Log Catching Errors Data.
*************************************************/

	SELECT [LogCatchingErrorsID]
		  ,[ErrorNumber]
		  ,[ErrorSeverity]
		  ,[ErrorState]
		  ,[ErrorProcedure]
		  ,[ErrorMessage]
		  ,[ErrorParameters]
		  ,[CreatedDate]
		  ,[LastModifiedDate]
		  ,1 AS [RecordCount]
	  FROM [maint].[tblLogCatchingErrors] with(nolock)