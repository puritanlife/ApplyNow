CREATE   PROCEDURE [dbo].[spSetLeadsNonLicenseStatus]
	(
		@LeadEmail [NVARCHAR](100) 
		, @LeadStatus [NVARCHAR](20)
	)
AS
BEGIN;
	/*---------------------------------------------------------------------------------------- 
	Author 		Date 			Description
	------------------------------------------------------------------------------------------  
	Poonam		9/23/2020		Update a Leads Non Licensed Status Record. 
	DZC			3/16/2021		Rewrote proc, previous version did a whole of unnecessary stuff 
								(assigning variables, erroring out on correlated subquery results, 
								uneccessary logging of proc calls. Work assigned in ticket #
								https://trello.com/c/CqmowQ3V/547-review-spsetleadsnonlicensestatus
	------------------------------------------------------------------------------------------  
	TAGS: Leads, Status
	*/
		
	SET NOCOUNT ON; 
	BEGIN TRY;
		DECLARE 
			@TranCount INT
			, @TransactionName SYSNAME =  LEFT(ISNULL(OBJECT_NAME(@@PROCID), 'Spid_' 
			+ CAST(@@SPID AS VARCHAR(30)) + '_' +  REPLACE(SUSER_SNAME(), 'coexist\', '')   ), 32);
	 
		/**
			 (> o.O)>~~~~	Code before transaction goes here	~~~~<(o.O <)
		**/
		
		DECLARE 
			@StartSPCall DATETIME = GETDATE()
			, @Procedure NVARCHAR(MAX) = (SELECT OBJECT_NAME(@@PROCID))
			, @Message NVARCHAR(MAX) = null 
			, @Output NVARCHAR(MAX) = null 
			, @Parameters NVARCHAR(MAX) = null
			, @RowCount INT		
			, @ErrorNumber INT
			, @ErrorSeverity INT
			, @ErrorState INT
			, @ErrorLine INT
			, @ErrorProcedure NVARCHAR(200)
			, @ErrorMessage VARCHAR(4000)
			, @XactState INT
		;

		SET @Message = @Message + ' Updates Status ';
		SET @Output = '@LeadEmailValid '+ @LeadEmail;						
		SET @Parameters = 
			' @Email ' + CAST(@LeadEmail AS NVARCHAR) +
			' @LeadStatus ' + CAST(@LeadStatus AS NVARCHAR) 
		;		
	 
		-- Get if the session is in transaction state yet or not
		SET @TranCount = @@TRANCOUNT;
		 
		-- Detect if the procedure was called from an active transaction and save that for later use. In the procedure, 
		-- @TranCount = 0 means there was no active transaction and the procedure started one. @TranCount > 0 means 
		-- an active transaction was started before the procedure was called.
		IF @TranCount = 0
		   -- No active transaction so begin one
		   BEGIN TRANSACTION;
		ELSE
		   -- Create a savepoint to be able to roll back only the work done in the procedure if there is an error
		   SAVE TRANSACTION @TransactionName;
	 
		/**
			 (> o.O)>~~~~	Code in transaction goes here	~~~~<(o.O <)
		**/

		/**
			THIS INDEX NEEDS TO BE CREATED AS PART OF THIS CHANGE
			CREATE INDEX idxLeadsNonLicenseStates ON [dbo].[tblLeadsNonLicenseStates] ([Email]);
		**/
		
		UPDATE [dbo].[tblLeadsNonLicenseStates]
		SET [LeadStatus] = @LeadStatus
		WHERE [Email]= @LeadEmail
		;
		
		SET @RowCount=@@ROWCOUNT;
		
		-- Include the RowCount check if the procedure needs to detect if no changes 
		-- actually occurred and either error off (raiserror or email someone)
		 
		-- If no record was updated/inserted/deleted
		-- IF @@ROWCOUNT = 0
		--   BEGIN;
		--<-- special code>
		--   END;
		 
		-- @TranCount = 0 means no transaction was started before the procedure was called.
		-- The procedure must commit the transaction it started.
		IF @TranCount = 0
		   COMMIT TRANSACTION;
		   
		IF @RowCount>0
			BEGIN		
				IF (SELECT dbo.CheckEnvironment())>0 
					BEGIN
						EXEC [maint].[spSetLogStoredProcedureCalls]
							@Procedure = @Procedure,
							@Message = @Message,
							@Parameters = @Parameters,
							@Output = @Output,
							@StartSPCall = @StartSPCall
						;
					END
				SELECT @RowCount AS Result
			END
			ELSE
			BEGIN
				SET @ErrorMessage= 'No records were updated';
				RAISERROR 
					(
						@ErrorMessage, -- Message text.
						16, 
						1,
						@ErrorNumber,
						@ErrorSeverity, -- Severity.
						@ErrorState, -- State.
						@ErrorProcedure,
						@ErrorLine
					);
				RETURN;
			END				   
	END TRY
	 
	/*------------------------------------------------------
	Special catch logic only good for CUD type procedures
	Because it does contains rollback code.
	------------------------------------------------------*/
	BEGIN CATCH
		-- First Assign variables to error-handling functions that capture information for RAISERROR.
		SELECT 
			@ErrorNumber = ERROR_NUMBER(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE(),
			@ErrorLine = ERROR_LINE(),
			@ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');
	 
		-- Building the message string that will contain original error information.
		SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 
							   N'Message: '+ ERROR_MESSAGE();
							   
		IF (SELECT dbo.CheckEnvironment())>0 
			BEGIN							   
				EXEC [maint].[spSetLogCatchingErrors]
					@ErrorNumber = @ErrorNumber,
					@ErrorSeverity = @ErrorSeverity,
					@ErrorState = @ErrorState,
					@ErrorProcedure = @Procedure,
					@ErrorMessage = @ErrorMessage,
					@ErrorParameters = @Parameters		
				;
			END

		-- Get the state of the existing transaction so we can tell what type of rollback needs to occur
		--    If 1, the transaction is committable.
		--    If -1, the transaction is uncommittable and should be rolled back but only if it is a Full roll back. Rollback for a save point will not work.
		--    XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		SET @XactState = XACT_STATE();
	 
		BEGIN TRY -- in case rollback fails wrap it in its own try/catch block
		IF @TranCount > 0 AND @XactState = 1 -- Proc came in with a tran state, and it is still in one that is committable so rollback the save point
		   ROLLBACK TRANSACTION @TransactionName;
		ELSE
		   IF @XactState <> 0 -- There is a transaction state to rollback so do a full one
			  ROLLBACK TRANSACTION; 
		END TRY
	 
		BEGIN CATCH -- do nothing if either the partial or the full rollbacks fail
		END CATCH;  -- So the error that is reported is what triggered the main catch
				
		-- Use RAISERROR inside the CATCH block to return error
		-- information about the original error that caused
		-- execution to jump to the CATCH block.
		RAISERROR 
			(
				@ErrorMessage, -- Message text.
				16, 
				1,
				@ErrorNumber,
				@ErrorSeverity, -- Severity.
				@ErrorState, -- State.
				@ErrorProcedure,
				@ErrorLine
			);
	 
		-- Return a negative number so that if the calling code is using a LINK server, it will
		-- be able to test that the procedure failed. Without this, there are some lower type of 
		-- errors that do not show up across the LINK as an error. This causes ProcessControl 
		-- in particular to not see that the procedure failed which is bad.
		RETURN -1;
	 
	END CATCH;
END;
GO


