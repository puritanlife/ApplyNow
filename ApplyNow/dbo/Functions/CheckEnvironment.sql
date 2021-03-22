
CREATE FUNCTION [dbo].[CheckEnvironment]()
RETURNS INT
AS
	BEGIN
		/*--------------------------------------------------------------------------------------------------------------------------------- 
		Author 		Date 			Description
		----------------------------------------------------------------------------------------------------------------------------------- 
		DZC			3/17/2021		This function is used to determine if current runtime envionrment is production or not
									(returns >0 if not production).
		-----------------------------------------------------------------------------------------------------------------------------------  
		TAGS: Canvas, Portal
		*/
		DECLARE @len INT 	  
		SET @len = 
			(
				SELECT 
					CHARINDEX('_DEV',db_name()+@@Servername, 1)
					+CHARINDEX('_TEST',db_name()+@@Servername, 1)
					+CHARINDEX('-DEV',db_name()+@@Servername, 1)
					+CHARINDEX('-TEST',db_name()+@@Servername, 1)
			)
		RETURN @len;		   
	END