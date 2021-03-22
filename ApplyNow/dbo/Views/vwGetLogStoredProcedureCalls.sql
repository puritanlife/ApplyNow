
CREATE VIEW [dbo].[vwGetLogStoredProcedureCalls]
AS
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 4/21/2020
  Description: Gets all Log Stored Procedure Calls Data.
*************************************************/

	SELECT [LogStoredProcedureCallsID]
		  ,[Procedure]
		  ,[Message]
		  ,[Parameters]
		  ,[Output]
		  ,[StartSPCall]
		  ,[EndSPCall]
		  ,[CreatedDate]
		  ,[LastModifiedDate]
		  , 1 AS [RecordCount]
	  FROM [maint].[tblLogStoredProcedureCalls] with(nolock)