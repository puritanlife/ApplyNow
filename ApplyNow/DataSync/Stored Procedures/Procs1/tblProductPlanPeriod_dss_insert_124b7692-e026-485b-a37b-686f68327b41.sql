CREATE PROCEDURE [DataSync].[tblProductPlanPeriod_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 Int,
	@P_5 Float,
	@P_6 Float,
	@P_7 Float,
	@P_8 DateTime,
	@P_9 DateTime,
	@P_10 DateTime,
	@P_11 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblProductPlanPeriod] WHERE [ProductPlanPeriodID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblProductPlanPeriod_dss_tracking] WHERE [ProductPlanPeriodID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblProductPlanPeriod] ON; INSERT INTO [dbo].[tblProductPlanPeriod]([ProductPlanPeriodID], [ProductTypeID], [PlanTypeID], [PeriodTypeID], [PremMin], [PremMax], [CreditingRate], [EffectiveDate], [EndDate], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblProductPlanPeriod] OFF; END 
END