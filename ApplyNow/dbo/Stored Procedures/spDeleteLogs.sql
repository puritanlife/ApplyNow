
CREATE procedure [dbo].[spDeleteLogs]
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/22/2020
  Description: Deletes records within log tables.
**************************************************/
	delete FROM [maint].[tblLogCatchingErrors];
	delete FROM [maint].[tblLogStoredProcedureCalls];
	delete FROM [maint].[tblVerificationExistingIDAgainstComment];

END