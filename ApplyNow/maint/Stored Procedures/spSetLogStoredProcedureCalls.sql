
CREATE procedure  [maint].[spSetLogStoredProcedureCalls]
(
    @Procedure nvarchar(255) null,
    @Message nvarchar(255) null,
    @Parameters nvarchar(255) null,
    @Output nvarchar(255) null,
	@StartSPCall datetime = null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/7/2020
  Description: Inserts a Log Stored Procedure Calls Record.
**************************************************/
	DECLARE @EndSPCall datetime = getdate()

	BEGIN

		INSERT INTO [maint].[tblLogStoredProcedureCalls]
			([Procedure]
			,[Message]
			,[Parameters]
			,[Output]
			,[StartSPCall]
			,[EndSPCall])
		VALUES
			(@Procedure
			,@Message
			,@Parameters
			,@Output
			,@StartSPCall
			,@EndSPCall)

	END

END