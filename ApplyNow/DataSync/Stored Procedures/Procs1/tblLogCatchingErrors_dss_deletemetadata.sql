CREATE PROCEDURE [DataSync].[tblLogCatchingErrors_dss_deletemetadata]
	@P_1 Int,
	@sync_check_concurrency Int,
	@sync_row_timestamp BigInt,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; DELETE [side] FROM [DataSync].[tblLogCatchingErrors_dss_tracking] [side] WHERE [LogCatchingErrorsID] = @P_1 AND (@sync_check_concurrency = 0 or [local_update_peer_timestamp] = @sync_row_timestamp);SET @sync_row_count = 1 ;

END