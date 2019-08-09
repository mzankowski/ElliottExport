
CREATE procedure [dbo].[export_to_elliottmarketing] (@p_control_groups varchar(100)) as
begin

/*
--added tr_section 08/06/12 by Mijala
	Added t_affiliation, tr_affiliation_type, tr_relationship_category 11/07/12 by Mijala
	created lv_t_address(does not have geo_location) and used instead of t_address to create t_address
	
	11/18/12 by Mijala
		changed to point to link not topgun
	03/04/15 by Mijala
		added tr_sli_status
	07/23/15 by Mijala
		added tx_cust_keyword
*/
--declare @p_control_groups varchar(100)
--set @p_control_groups = '10,11,15'

DECLARE @errcnt INT, @errmsg nvarchar(1000), @reccnt INT, @errnum INT
SET @errcnt = 0

--USE PSS_ElliottMarketing

SET NOCOUNT ON
--select * from link.impresario_restore.dbo.tr_control_group

TRUNCATE TABLE PSS_ElliottMarketing.dbo.export_counts

PRINT 'T_FUND '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_fund]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_fund
	FROM link.impresario_restore.dbo.t_fund
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
	
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_fund', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_fund', @reccnt)
	
		CREATE CLUSTERED INDEX t_fund_no ON PSS_ElliottMarketing.dbo.t_fund (fund_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_fund', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_CAMPAIGN_CATEGORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_campaign_category]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.tr_campaign_category
	FROM link.impresario_restore.dbo.tr_campaign_category
	
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_campaign_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_campaign_category', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_campaign_category', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CAMPAIGN '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_campaign]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_campaign
	FROM link.impresario_restore.dbo.t_campaign
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
	
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_campaign', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_campaign', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_campaign', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TX_CAMP_FUND'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_camp_fund]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_camp_fund
	FROM link.impresario_restore.dbo.tx_camp_fund a
		INNER JOIN PSS_ElliottMarketing.dbo.t_campaign b ON a.campaign_no = b.campaign_no
		INNER JOIN PSS_ElliottMarketing.dbo.t_fund c ON a.fund_no = c.fund_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_camp_fund', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_camp_fund', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_camp_fund', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_APPEAL '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_appeal]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_appeal
	FROM link.impresario_restore.dbo.t_appeal
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_appeal', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_appeal', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_appeal', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_Appeal_Category'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_appeal_category]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_appeal_category 
	FROM link.impresario_restore.dbo.tr_appeal_category a
		INNER JOIN PSS_ElliottMarketing.dbo.t_appeal b ON a.id = b.category

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_appeal_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_appeal_category', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_appeal_category', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'TX_APPEAL_MEDIA_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_appeal_media_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_appeal_media_type
	FROM link.impresario_restore.dbo.tx_appeal_media_type a
		INNER JOIN PSS_ElliottMarketing.dbo.t_appeal b ON a.appeal_no = b.appeal_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_appeal_media_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_appeal_media_type', @reccnt)
	
		CREATE CLUSTERED INDEX tx_appeal_media_type_source_no ON PSS_ElliottMarketing.dbo.tx_appeal_media_type (source_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_appeal_media_type', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_FACILITY '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_facility]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_facility
	FROM link.impresario_restore.dbo.t_facility
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_facility', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_facility', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_facility', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_SEASON'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_season]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.tr_season
	FROM link.impresario_restore.dbo.tr_season
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_season', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_season', @reccnt)
	
		CREATE CLUSTERED INDEX tr_season_id ON PSS_ElliottMarketing.dbo.tr_season (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_season', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_SEASON_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_season_type]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.tr_season_type
	FROM link.impresario_restore.dbo.tr_season_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tr_season WHERE type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_season_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_season_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_season_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_PROD_SEASON '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_prod_season]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_prod_season
	FROM link.impresario_restore.dbo.t_prod_season a
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season b ON a.season = b.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_prod_season', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_prod_season', @reccnt)
	
		CREATE CLUSTERED INDEX t_prod_season_no ON PSS_ElliottMarketing.dbo.t_prod_season (prod_season_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_prod_season', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_PRODUCTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_production]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_production
	FROM link.impresario_restore.dbo.t_production a
		INNER JOIN PSS_ElliottMarketing.dbo.t_prod_season b ON a.prod_no = b.prod_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_production', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_production', @reccnt)
	
		CREATE CLUSTERED INDEX t_production_no ON PSS_ElliottMarketing.dbo.t_production (prod_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_production', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_PERF '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_perf]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_perf
	FROM link.impresario_restore.dbo.t_perf a
		INNER JOIN PSS_ElliottMarketing.dbo.t_prod_season b ON a.prod_season_no = b.prod_season_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_perf', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_perf', @reccnt)
	
		CREATE CLUSTERED INDEX t_perf_no ON PSS_ElliottMarketing.dbo.t_perf (perf_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_perf', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PERF_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_perf_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_perf_type
	FROM link.impresario_restore.dbo.tr_perf_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_perf WHERE perf_type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_perf_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_perf_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_perf_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_PKG '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_pkg]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_pkg
	FROM link.impresario_restore.dbo.t_pkg a
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season b ON a.season = b.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_pkg', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_pkg', @reccnt)
	
		CREATE CLUSTERED INDEX t_pkg_no ON PSS_ElliottMarketing.dbo.t_pkg (pkg_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_pkg', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'TR_PKG_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_pkg_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_pkg_type
	FROM link.impresario_restore.dbo.tr_pkg_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_pkg WHERE pkg_type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_pkg_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_pkg_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_pkg_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_TITLE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_title]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_title
	FROM link.impresario_restore.dbo.t_title a
		INNER JOIN PSS_ElliottMarketing.dbo.t_production b ON a.title_no = b.title_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_title', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_title', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_title', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_INVENTORY '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_inventory]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_inventory
	FROM link.impresario_restore.dbo.t_inventory a
		LEFT JOIN PSS_ElliottMarketing.dbo.t_title b ON a.inv_no = b.title_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_production c ON a.inv_no = c.prod_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_prod_season d ON a.inv_no = d.prod_season_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_perf e ON a.inv_no = e.perf_no
	WHERE b.title_no IS NOT NULL
		OR c.prod_no IS NOT NULL
		OR d.prod_season_no IS NOT NULL
		OR e.perf_no IS NOT NULL

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_inventory', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_inventory', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_inventory', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_CONSTITUENCY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_constituency]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_constituency
	FROM link.impresario_restore.dbo.tr_constituency a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_constituency', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_constituency', @reccnt)
	
		CREATE CLUSTERED INDEX tr_constituency_id ON PSS_ElliottMarketing.dbo.tr_constituency (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_constituency', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TX_CONST_CUST'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_const_cust]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_const_cust
	FROM link.impresario_restore.dbo.tx_const_cust a
		INNER JOIN PSS_ElliottMarketing.dbo.tr_constituency b ON a.constituency = b.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_const_cust', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_const_cust', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_const_cust', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CUSTOMER '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_customer]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_customer
	FROM link.impresario_restore.dbo.t_customer a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tx_const_cust WHERE customer_no = a.customer_no)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_customer', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_customer', @reccnt)
	
		CREATE CLUSTERED INDEX t_customer_no ON PSS_ElliottMarketing.dbo.t_customer (customer_no)
		CREATE INDEX t_customer_prefix ON PSS_ElliottMarketing.dbo.t_customer (prefix)
		CREATE INDEX t_customer_prefix2 ON PSS_ElliottMarketing.dbo.t_customer (prefix2)
		CREATE INDEX t_customer_suffix ON PSS_ElliottMarketing.dbo.t_customer (suffix)
		CREATE INDEX t_customer_suffix2 ON PSS_ElliottMarketing.dbo.t_customer (suffix2)
		CREATE INDEX t_customer_type ON PSS_ElliottMarketing.dbo.t_customer (cust_type)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_customer', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_PROMOTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_promotion]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_promotion
	FROM link.impresario_restore.dbo.t_promotion a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tx_appeal_media_type c ON a.source_no = c.source_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_promotion', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_promotion', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_promotion', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PHONE_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_phone_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_phone_type
	FROM link.impresario_restore.dbo.tr_phone_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR isnull(control_group,-1) = -1

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_phone_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_phone_type', @reccnt)
	
		CREATE CLUSTERED INDEX tr_phone_type_id ON PSS_ElliottMarketing.dbo.tr_phone_type (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_phone_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_KEYWORD '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_keyword]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_keyword
	FROM link.impresario_restore.dbo.t_keyword a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_keyword', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_keyword', @reccnt)
	
		CREATE CLUSTERED INDEX t_keyword_no ON PSS_ElliottMarketing.dbo.t_keyword (keyword_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_keyword', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_KWCODED_VALUES '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_kwcoded_values]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_kwcoded_values
	FROM link.impresario_restore.dbo.t_kwcoded_values a
		INNER JOIN PSS_ElliottMarketing.dbo.t_keyword b ON a.keyword_no = b.keyword_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_kwcoded_values', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_kwcoded_values', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_kwcoded_values', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_ADDRESS_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_address_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_address_type
	FROM link.impresario_restore.dbo.tr_address_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR isnull(control_group,-1) = -1

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_address_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_address_type', @reccnt)
	
		CREATE CLUSTERED INDEX tr_address_type_id ON PSS_ElliottMarketing.dbo.tr_address_type (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_address_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_ADDRESS '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_address]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_address
	FROM link.impresario_restore.dbo.lv_t_address a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM PSS_ElliottMarketing.dbo.tr_address_type WHERE control_group IS NOT NULL) c ON a.address_type = c.id
	WHERE c.id IS NOT NULL
		OR a.primary_ind = 'Y' 

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_address', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_address', @reccnt)
	
		CREATE CLUSTERED INDEX t_address_no ON PSS_ElliottMarketing.dbo.t_address (address_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_address', 'already exists')
	SET @errcnt = @errcnt + 1
END
	

PRINT 'T_EADDRESS '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_eaddress]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_eaddress 
	FROM link.impresario_restore.dbo.t_eaddress a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM link.impresario_restore.dbo.tr_eaddress_type WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.eaddress_type = c.id
	WHERE c.id IS NOT NULL
		OR a.primary_ind = 'Y'

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_eaddress', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_eaddress', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_eaddress', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_RANK_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_rank_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_rank_type
	FROM link.impresario_restore.dbo.tr_rank_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR isnull(control_group,-1) = -1

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_rank_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_rank_type', @reccnt)
	
		CREATE CLUSTERED INDEX tr_rank_type_id ON PSS_ElliottMarketing.dbo.tr_rank_type (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_rank_type', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_CUST_TYPE (pull based ON t_customer)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_cust_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_cust_type
	FROM link.impresario_restore.dbo.tr_cust_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer WHERE cust_type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_cust_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_cust_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_cust_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PREFIX (pull based ON t_customer)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_prefix]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_prefix
	FROM link.impresario_restore.dbo.tr_prefix a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where prefix = isnull(a.id,-1))
		OR EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where prefix2 = isnull(a.id,-1))

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_prefix', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_prefix', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_prefix', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'TR_SUFFIX (pull based ON t_customer)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_suffix]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_suffix
	FROM link.impresario_restore.dbo.tr_suffix a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where suffix = isnull(a.id,-1))
		OR EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where suffix2 = isnull(a.id,-1))

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_suffix', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_suffix', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_suffix', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TX_CUST_SAL'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_sal]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_sal
	FROM link.impresario_restore.dbo.tx_cust_sal a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM link.impresario_restore.dbo.tr_signor WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.signor = c.id
	WHERE a.default_ind = 'Y' or c.id IS NOT NULL

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_sal', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_cust_sal', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_sal', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_PHONE '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_phone]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_phone 
	FROM link.impresario_restore.dbo.t_phone a
		LEFT JOIN PSS_ElliottMarketing.dbo.t_address b ON a.address_no = b.address_no
		LEFT JOIN PSS_ElliottMarketing.dbo.tr_phone_type c ON a.type = c.id
	WHERE b.address_no IS NOT NULL 
		OR c.id IS NOT NULL

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_phone', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_phone', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_phone', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CUST_RANK '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_rank]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_cust_rank
	FROM link.impresario_restore.dbo.t_cust_rank a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tr_rank_type c ON a.rank_type = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_cust_rank', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_cust_rank', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_cust_rank', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'TX_CUST_TKW'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_tkw]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_tkw 
	FROM link.impresario_restore.dbo.tx_cust_tkw a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN (SELECT * FROM link.impresario_restore.dbo.tr_tkw WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.tkw = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_tkw', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_cust_tkw', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_tkw', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CONTRIBUTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_contribution]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_contribution
	FROM link.impresario_restore.dbo.t_contribution a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.t_fund c ON a.fund_no = c.fund_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_contribution', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_contribution', @reccnt)
	
		CREATE CLUSTERED INDEX t_contribution_ref_no ON PSS_ElliottMarketing.dbo.t_contribution (ref_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_contribution', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CREDITEE '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_creditee]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_creditee
	FROM link.impresario_restore.dbo.t_creditee a
		INNER JOIN PSS_ElliottMarketing.dbo.t_contribution b ON a.ref_no = b.ref_no
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer c ON a.creditee_no = c.customer_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_creditee', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_creditee', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_creditee', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_SCHEDULE '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_schedule]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_schedule
	FROM link.impresario_restore.dbo.t_schedule a
		INNER JOIN PSS_ElliottMarketing.dbo.t_contribution b ON a.ref_no = b.ref_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_schedule', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_schedule', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_schedule', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_SECTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_section]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_section
	FROM link.impresario_restore.dbo.tr_section a

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_section', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_section', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_section', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CUST_SUBSCRIPTION_SUMMARY '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_subscription_summary]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_cust_subscription_summary
	FROM link.impresario_restore.dbo.t_cust_subscription_summary a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season c ON a.season = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_cust_subscription_summary', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_cust_subscription_summary', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_cust_subscription_summary', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'LT_SUBSCRIPTION_HIST'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lt_subscription_hist]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.lt_subscription_hist
	FROM link.impresario_restore.dbo.lt_subscription_hist a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season c ON a.season = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('lt_subscription_hist', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('lt_subscription_hist', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('lt_subscription_hist', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'LT_TCK_HIST'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lt_tck_hist]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.lt_tck_hist
	FROM link.impresario_restore.dbo.lt_tck_hist a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season c ON a.season = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('lt_tck_hist', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('lt_tck_hist', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('lt_tck_hist', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_ORDER '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_order]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_order
	FROM link.impresario_restore.dbo.t_order a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
	WHERE EXISTS (SELECT 1 FROM link.impresario_restore.dbo.t_lineitem c 
					INNER JOIN PSS_ElliottMarketing.dbo.t_perf d ON c.perf_no = d.perf_no
					WHERE c.order_no = a.order_no)
		OR EXISTS (SELECT 1 FROM link.impresario_restore.dbo.t_lineitem e
					INNER JOIN PSS_ElliottMarketing.dbo.t_pkg f ON e.pkg_no = f.pkg_no
					WHERE e.order_no = a.order_no)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_order', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_order', @reccnt)
	
		CREATE CLUSTERED INDEX t_order_no ON PSS_ElliottMarketing.dbo.t_order (order_no)
		CREATE INDEX t_order_mos ON PSS_ElliottMarketing.dbo.t_order (mos)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_order', 'already exists')
	SET @errcnt = @errcnt + 1
END
				
PRINT 'T_LINEITEM '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_lineitem]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_lineitem
	FROM link.impresario_restore.dbo.t_lineitem a
		INNER JOIN PSS_ElliottMarketing.dbo.t_order b ON a.order_no = b.order_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_perf c ON a.perf_no = c.perf_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_pkg d ON a.pkg_no = d.pkg_no
	WHERE c.perf_no IS NOT NULL
		OR d.pkg_no IS NOT NULL

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_lineitem', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_lineitem', @reccnt)
	
		CREATE CLUSTERED INDEX t_lineitem_seq_no ON PSS_ElliottMarketing.dbo.t_lineitem (li_seq_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_lineitem', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_SUB_LINEITEM'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_sub_lineitem]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_sub_lineitem
	FROM link.impresario_restore.dbo.t_sub_lineitem a
		INNER JOIN PSS_ElliottMarketing.dbo.t_lineitem b ON a.li_seq_no = b.li_seq_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_sub_lineitem', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_sub_lineitem', @reccnt)
	
		CREATE INDEX t_sub_lineitem_seat_no ON PSS_ElliottMarketing.dbo.t_sub_lineitem (seat_no)
		CREATE INDEX t_sub_lineitem_price_type ON PSS_ElliottMarketing.dbo.t_sub_lineitem (price_type)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_sub_lineitem', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_ORDER_SEAT_HIST '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_order_seat_hist]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_order_seat_hist
	FROM link.impresario_restore.dbo.t_order_seat_hist a
		INNER JOIN PSS_ElliottMarketing.dbo.t_order b ON a.order_no = b.order_no
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer c ON a.customer_no = c.customer_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_order_seat_hist', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_order_seat_hist', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_order_seat_hist', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_SEAT '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_seat]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_seat
	FROM link.impresario_restore.dbo.t_seat a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_sub_lineitem WHERE seat_no = a.seat_no)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_seat', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_seat', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_seat', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_MOS (pull based ON orders)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_mos]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_mos
	FROM link.impresario_restore.dbo.tr_mos a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_order WHERE mos = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_mos', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_mos', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_mos', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_MOS_CATEGORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_mos_category]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_mos_category
	FROM link.impresario_restore.dbo.tr_mos_category a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tr_mos WHERE category = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_mos_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_mos_category', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_mos_category', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PRICE_TYPE (pull based ON sub_lineitems)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_price_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_price_type
	FROM link.impresario_restore.dbo.tr_price_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_sub_lineitem WHERE price_type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_price_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_price_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_price_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PRICE_TYPE_CATEGORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_price_type_category]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_price_type_category
	FROM link.impresario_restore.dbo.tr_price_type_category a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tr_price_type WHERE price_type_category = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_price_type_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_price_type_category', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_price_type_category', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'T_AFFILIATION'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].t_affiliation') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_affiliation
	FROM link.impresario_restore.dbo.t_affiliation a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tx_const_cust WHERE customer_no = a.individual_customer_no)
		or EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tx_const_cust WHERE customer_no = a.group_customer_no)
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_affiliation', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_affiliation', @reccnt)
	
		CREATE CLUSTERED INDEX t_affiliation_no ON PSS_ElliottMarketing.dbo.t_affiliation (affiliation_no)
		CREATE INDEX t_individual_customer_no ON PSS_ElliottMarketing.dbo.t_affiliation (individual_customer_no)
		CREATE INDEX t_group_customer_no ON PSS_ElliottMarketing.dbo.t_affiliation (group_customer_no)
		CREATE INDEX t_affiliation_type_id ON PSS_ElliottMarketing.dbo.t_affiliation (affiliation_type_id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_affiliation', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_AFFILIATION_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].tr_affiliation_type') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_affiliation_type
	FROM link.impresario_restore.dbo.tr_affiliation_type a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_affiliation_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_affiliation_type', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_affiliation_type', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_RELATIONSHIP_CATEGORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].tr_relationship_category') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_relationship_category
	FROM link.impresario_restore.dbo.tr_relationship_category a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_relationship_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_relationship_category', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_relationship_category', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_PERF_PRICE_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].T_PERF_PRICE_TYPE') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.T_PERF_PRICE_TYPE
	FROM link.impresario_restore.dbo.T_PERF_PRICE_TYPE a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PERF_PRICE_TYPE', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('T_PERF_PRICE_TYPE', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PERF_PRICE_TYPE', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'T_PERF_PRICE_LAYER'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].T_PERF_PRICE_LAYER') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.T_PERF_PRICE_LAYER
	FROM link.impresario_restore.dbo.T_PERF_PRICE_LAYER a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PERF_PRICE_LAYER', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('T_PERF_PRICE_LAYER', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PERF_PRICE_LAYER', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_PRICE_LAYER_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].TR_PRICE_LAYER_TYPE') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.TR_PRICE_LAYER_TYPE
	FROM link.impresario_restore.dbo.TR_PRICE_LAYER_TYPE a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TR_PRICE_LAYER_TYPE', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('TR_PRICE_LAYER_TYPE', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TR_PRICE_LAYER_TYPE', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_TICKET_HISTORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].T_TICKET_HISTORY') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.T_TICKET_HISTORY
	FROM link.impresario_restore.dbo.T_TICKET_HISTORY a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_TICKET_HISTORY', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('T_TICKET_HISTORY', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_TICKET_HISTORY', 'already exists')
	SET @errcnt = @errcnt + 1
END



PRINT 'T_PACKAGE_HISTORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].T_PACKAGE_HISTORY') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.T_PACKAGE_HISTORY
	FROM link.impresario_restore.dbo.T_PACKAGE_HISTORY a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PACKAGE_HISTORY', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('T_PACKAGE_HISTORY', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PACKAGE_HISTORY', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TX_CONTACT_POINT_PURPOSE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].TX_CONTACT_POINT_PURPOSE') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.TX_CONTACT_POINT_PURPOSE
	FROM link.impresario_restore.dbo.TX_CONTACT_POINT_PURPOSE a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TX_CONTACT_POINT_PURPOSE', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('TX_CONTACT_POINT_PURPOSE', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TX_CONTACT_POINT_PURPOSE', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_SLI_STATUS'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].TR_SLI_STATUS') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.TR_SLI_STATUS
	FROM link.impresario_restore.dbo.TR_SLI_STATUS a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TR_SLI_STATUS', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('TR_SLI_STATUS', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TR_SLI_STATUS', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TX_CUST_KEYWORD'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_keyword]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_keyword
	FROM link.impresario_restore.dbo.tx_cust_keyword a
		INNER JOIN PSS_ElliottMarketing.dbo.t_keyword b ON a.keyword_no = b.keyword_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_keyword', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_cust_keyword', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_keyword', 'already exists')
	SET @errcnt = @errcnt + 1
END



INSERT INTO PSS_ElliottMarketing.dbo.export_log (process,result,control_groups) 
VALUES ('data exported', CASE WHEN @errcnt = 0 THEN 'success' ELSE 'failure - check export_counts table' END, @p_control_groups)

end


CREATE procedure [dbo].[export_to_elliottmarketing] (@p_control_groups varchar(100)) as
begin

/*
--added tr_section 08/06/12 by Mijala
	Added t_affiliation, tr_affiliation_type, tr_relationship_category 11/07/12 by Mijala
	created lv_t_address(does not have geo_location) and used instead of t_address to create t_address
	
	11/18/12 by Mijala
		changed to point to link not topgun
	03/04/15 by Mijala
		added tr_sli_status
	07/23/15 by Mijala
		added tx_cust_keyword
*/
--declare @p_control_groups varchar(100)
--set @p_control_groups = '10,11,15'

DECLARE @errcnt INT, @errmsg nvarchar(1000), @reccnt INT, @errnum INT
SET @errcnt = 0

--USE PSS_ElliottMarketing

SET NOCOUNT ON
--select * from link.impresario_restore.dbo.tr_control_group

TRUNCATE TABLE PSS_ElliottMarketing.dbo.export_counts

PRINT 'T_FUND '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_fund]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_fund
	FROM link.impresario_restore.dbo.t_fund
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
	
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_fund', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_fund', @reccnt)
	
		CREATE CLUSTERED INDEX t_fund_no ON PSS_ElliottMarketing.dbo.t_fund (fund_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_fund', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_CAMPAIGN_CATEGORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_campaign_category]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.tr_campaign_category
	FROM link.impresario_restore.dbo.tr_campaign_category
	
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_campaign_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_campaign_category', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_campaign_category', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CAMPAIGN '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_campaign]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_campaign
	FROM link.impresario_restore.dbo.t_campaign
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
	
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_campaign', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_campaign', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_campaign', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TX_CAMP_FUND'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_camp_fund]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_camp_fund
	FROM link.impresario_restore.dbo.tx_camp_fund a
		INNER JOIN PSS_ElliottMarketing.dbo.t_campaign b ON a.campaign_no = b.campaign_no
		INNER JOIN PSS_ElliottMarketing.dbo.t_fund c ON a.fund_no = c.fund_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_camp_fund', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_camp_fund', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_camp_fund', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_APPEAL '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_appeal]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_appeal
	FROM link.impresario_restore.dbo.t_appeal
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_appeal', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_appeal', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_appeal', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_Appeal_Category'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_appeal_category]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_appeal_category 
	FROM link.impresario_restore.dbo.tr_appeal_category a
		INNER JOIN PSS_ElliottMarketing.dbo.t_appeal b ON a.id = b.category

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_appeal_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_appeal_category', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_appeal_category', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'TX_APPEAL_MEDIA_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_appeal_media_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_appeal_media_type
	FROM link.impresario_restore.dbo.tx_appeal_media_type a
		INNER JOIN PSS_ElliottMarketing.dbo.t_appeal b ON a.appeal_no = b.appeal_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_appeal_media_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_appeal_media_type', @reccnt)
	
		CREATE CLUSTERED INDEX tx_appeal_media_type_source_no ON PSS_ElliottMarketing.dbo.tx_appeal_media_type (source_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_appeal_media_type', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_FACILITY '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_facility]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_facility
	FROM link.impresario_restore.dbo.t_facility
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_facility', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_facility', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_facility', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_SEASON'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_season]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.tr_season
	FROM link.impresario_restore.dbo.tr_season
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_season', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_season', @reccnt)
	
		CREATE CLUSTERED INDEX tr_season_id ON PSS_ElliottMarketing.dbo.tr_season (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_season', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_SEASON_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_season_type]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.tr_season_type
	FROM link.impresario_restore.dbo.tr_season_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tr_season WHERE type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_season_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_season_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_season_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_PROD_SEASON '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_prod_season]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_prod_season
	FROM link.impresario_restore.dbo.t_prod_season a
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season b ON a.season = b.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_prod_season', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_prod_season', @reccnt)
	
		CREATE CLUSTERED INDEX t_prod_season_no ON PSS_ElliottMarketing.dbo.t_prod_season (prod_season_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_prod_season', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_PRODUCTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_production]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_production
	FROM link.impresario_restore.dbo.t_production a
		INNER JOIN PSS_ElliottMarketing.dbo.t_prod_season b ON a.prod_no = b.prod_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_production', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_production', @reccnt)
	
		CREATE CLUSTERED INDEX t_production_no ON PSS_ElliottMarketing.dbo.t_production (prod_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_production', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_PERF '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_perf]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_perf
	FROM link.impresario_restore.dbo.t_perf a
		INNER JOIN PSS_ElliottMarketing.dbo.t_prod_season b ON a.prod_season_no = b.prod_season_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_perf', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_perf', @reccnt)
	
		CREATE CLUSTERED INDEX t_perf_no ON PSS_ElliottMarketing.dbo.t_perf (perf_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_perf', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PERF_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_perf_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_perf_type
	FROM link.impresario_restore.dbo.tr_perf_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_perf WHERE perf_type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_perf_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_perf_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_perf_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_PKG '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_pkg]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_pkg
	FROM link.impresario_restore.dbo.t_pkg a
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season b ON a.season = b.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_pkg', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_pkg', @reccnt)
	
		CREATE CLUSTERED INDEX t_pkg_no ON PSS_ElliottMarketing.dbo.t_pkg (pkg_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_pkg', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'TR_PKG_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_pkg_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_pkg_type
	FROM link.impresario_restore.dbo.tr_pkg_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_pkg WHERE pkg_type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_pkg_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_pkg_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_pkg_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_TITLE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_title]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_title
	FROM link.impresario_restore.dbo.t_title a
		INNER JOIN PSS_ElliottMarketing.dbo.t_production b ON a.title_no = b.title_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_title', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_title', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_title', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_INVENTORY '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_inventory]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_inventory
	FROM link.impresario_restore.dbo.t_inventory a
		LEFT JOIN PSS_ElliottMarketing.dbo.t_title b ON a.inv_no = b.title_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_production c ON a.inv_no = c.prod_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_prod_season d ON a.inv_no = d.prod_season_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_perf e ON a.inv_no = e.perf_no
	WHERE b.title_no IS NOT NULL
		OR c.prod_no IS NOT NULL
		OR d.prod_season_no IS NOT NULL
		OR e.perf_no IS NOT NULL

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_inventory', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_inventory', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_inventory', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_CONSTITUENCY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_constituency]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_constituency
	FROM link.impresario_restore.dbo.tr_constituency a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_constituency', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_constituency', @reccnt)
	
		CREATE CLUSTERED INDEX tr_constituency_id ON PSS_ElliottMarketing.dbo.tr_constituency (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_constituency', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TX_CONST_CUST'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_const_cust]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_const_cust
	FROM link.impresario_restore.dbo.tx_const_cust a
		INNER JOIN PSS_ElliottMarketing.dbo.tr_constituency b ON a.constituency = b.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_const_cust', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_const_cust', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_const_cust', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CUSTOMER '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_customer]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_customer
	FROM link.impresario_restore.dbo.t_customer a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tx_const_cust WHERE customer_no = a.customer_no)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_customer', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_customer', @reccnt)
	
		CREATE CLUSTERED INDEX t_customer_no ON PSS_ElliottMarketing.dbo.t_customer (customer_no)
		CREATE INDEX t_customer_prefix ON PSS_ElliottMarketing.dbo.t_customer (prefix)
		CREATE INDEX t_customer_prefix2 ON PSS_ElliottMarketing.dbo.t_customer (prefix2)
		CREATE INDEX t_customer_suffix ON PSS_ElliottMarketing.dbo.t_customer (suffix)
		CREATE INDEX t_customer_suffix2 ON PSS_ElliottMarketing.dbo.t_customer (suffix2)
		CREATE INDEX t_customer_type ON PSS_ElliottMarketing.dbo.t_customer (cust_type)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_customer', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_PROMOTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_promotion]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_promotion
	FROM link.impresario_restore.dbo.t_promotion a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tx_appeal_media_type c ON a.source_no = c.source_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_promotion', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_promotion', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_promotion', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PHONE_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_phone_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_phone_type
	FROM link.impresario_restore.dbo.tr_phone_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR isnull(control_group,-1) = -1

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_phone_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_phone_type', @reccnt)
	
		CREATE CLUSTERED INDEX tr_phone_type_id ON PSS_ElliottMarketing.dbo.tr_phone_type (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_phone_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_KEYWORD '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_keyword]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_keyword
	FROM link.impresario_restore.dbo.t_keyword a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_keyword', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_keyword', @reccnt)
	
		CREATE CLUSTERED INDEX t_keyword_no ON PSS_ElliottMarketing.dbo.t_keyword (keyword_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_keyword', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_KWCODED_VALUES '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_kwcoded_values]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_kwcoded_values
	FROM link.impresario_restore.dbo.t_kwcoded_values a
		INNER JOIN PSS_ElliottMarketing.dbo.t_keyword b ON a.keyword_no = b.keyword_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_kwcoded_values', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_kwcoded_values', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_kwcoded_values', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_ADDRESS_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_address_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_address_type
	FROM link.impresario_restore.dbo.tr_address_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR isnull(control_group,-1) = -1

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_address_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_address_type', @reccnt)
	
		CREATE CLUSTERED INDEX tr_address_type_id ON PSS_ElliottMarketing.dbo.tr_address_type (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_address_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_ADDRESS '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_address]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_address
	FROM link.impresario_restore.dbo.lv_t_address a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM PSS_ElliottMarketing.dbo.tr_address_type WHERE control_group IS NOT NULL) c ON a.address_type = c.id
	WHERE c.id IS NOT NULL
		OR a.primary_ind = 'Y' 

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_address', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_address', @reccnt)
	
		CREATE CLUSTERED INDEX t_address_no ON PSS_ElliottMarketing.dbo.t_address (address_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_address', 'already exists')
	SET @errcnt = @errcnt + 1
END
	

PRINT 'T_EADDRESS '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_eaddress]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_eaddress 
	FROM link.impresario_restore.dbo.t_eaddress a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM link.impresario_restore.dbo.tr_eaddress_type WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.eaddress_type = c.id
	WHERE c.id IS NOT NULL
		OR a.primary_ind = 'Y'

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_eaddress', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_eaddress', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_eaddress', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_RANK_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_rank_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_rank_type
	FROM link.impresario_restore.dbo.tr_rank_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR isnull(control_group,-1) = -1

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_rank_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_rank_type', @reccnt)
	
		CREATE CLUSTERED INDEX tr_rank_type_id ON PSS_ElliottMarketing.dbo.tr_rank_type (id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_rank_type', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_CUST_TYPE (pull based ON t_customer)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_cust_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_cust_type
	FROM link.impresario_restore.dbo.tr_cust_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer WHERE cust_type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_cust_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_cust_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_cust_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PREFIX (pull based ON t_customer)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_prefix]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_prefix
	FROM link.impresario_restore.dbo.tr_prefix a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where prefix = isnull(a.id,-1))
		OR EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where prefix2 = isnull(a.id,-1))

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_prefix', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_prefix', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_prefix', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'TR_SUFFIX (pull based ON t_customer)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_suffix]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_suffix
	FROM link.impresario_restore.dbo.tr_suffix a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where suffix = isnull(a.id,-1))
		OR EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where suffix2 = isnull(a.id,-1))

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_suffix', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_suffix', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_suffix', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TX_CUST_SAL'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_sal]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_sal
	FROM link.impresario_restore.dbo.tx_cust_sal a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM link.impresario_restore.dbo.tr_signor WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.signor = c.id
	WHERE a.default_ind = 'Y' or c.id IS NOT NULL

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_sal', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_cust_sal', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_sal', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_PHONE '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_phone]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_phone 
	FROM link.impresario_restore.dbo.t_phone a
		LEFT JOIN PSS_ElliottMarketing.dbo.t_address b ON a.address_no = b.address_no
		LEFT JOIN PSS_ElliottMarketing.dbo.tr_phone_type c ON a.type = c.id
	WHERE b.address_no IS NOT NULL 
		OR c.id IS NOT NULL

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_phone', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_phone', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_phone', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CUST_RANK '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_rank]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_cust_rank
	FROM link.impresario_restore.dbo.t_cust_rank a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tr_rank_type c ON a.rank_type = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_cust_rank', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_cust_rank', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_cust_rank', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'TX_CUST_TKW'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_tkw]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_tkw 
	FROM link.impresario_restore.dbo.tx_cust_tkw a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN (SELECT * FROM link.impresario_restore.dbo.tr_tkw WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.tkw = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_tkw', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_cust_tkw', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_tkw', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CONTRIBUTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_contribution]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_contribution
	FROM link.impresario_restore.dbo.t_contribution a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.t_fund c ON a.fund_no = c.fund_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_contribution', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_contribution', @reccnt)
	
		CREATE CLUSTERED INDEX t_contribution_ref_no ON PSS_ElliottMarketing.dbo.t_contribution (ref_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_contribution', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CREDITEE '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_creditee]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_creditee
	FROM link.impresario_restore.dbo.t_creditee a
		INNER JOIN PSS_ElliottMarketing.dbo.t_contribution b ON a.ref_no = b.ref_no
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer c ON a.creditee_no = c.customer_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_creditee', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_creditee', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_creditee', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_SCHEDULE '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_schedule]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_schedule
	FROM link.impresario_restore.dbo.t_schedule a
		INNER JOIN PSS_ElliottMarketing.dbo.t_contribution b ON a.ref_no = b.ref_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_schedule', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_schedule', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_schedule', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_SECTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_section]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_section
	FROM link.impresario_restore.dbo.tr_section a

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_section', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_section', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_section', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_CUST_SUBSCRIPTION_SUMMARY '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_subscription_summary]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_cust_subscription_summary
	FROM link.impresario_restore.dbo.t_cust_subscription_summary a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season c ON a.season = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_cust_subscription_summary', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_cust_subscription_summary', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_cust_subscription_summary', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'LT_SUBSCRIPTION_HIST'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lt_subscription_hist]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.lt_subscription_hist
	FROM link.impresario_restore.dbo.lt_subscription_hist a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season c ON a.season = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('lt_subscription_hist', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('lt_subscription_hist', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('lt_subscription_hist', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'LT_TCK_HIST'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lt_tck_hist]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.lt_tck_hist
	FROM link.impresario_restore.dbo.lt_tck_hist a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN PSS_ElliottMarketing.dbo.tr_season c ON a.season = c.id

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('lt_tck_hist', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('lt_tck_hist', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('lt_tck_hist', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_ORDER '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_order]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_order
	FROM link.impresario_restore.dbo.t_order a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
	WHERE EXISTS (SELECT 1 FROM link.impresario_restore.dbo.t_lineitem c 
					INNER JOIN PSS_ElliottMarketing.dbo.t_perf d ON c.perf_no = d.perf_no
					WHERE c.order_no = a.order_no)
		OR EXISTS (SELECT 1 FROM link.impresario_restore.dbo.t_lineitem e
					INNER JOIN PSS_ElliottMarketing.dbo.t_pkg f ON e.pkg_no = f.pkg_no
					WHERE e.order_no = a.order_no)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_order', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_order', @reccnt)
	
		CREATE CLUSTERED INDEX t_order_no ON PSS_ElliottMarketing.dbo.t_order (order_no)
		CREATE INDEX t_order_mos ON PSS_ElliottMarketing.dbo.t_order (mos)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_order', 'already exists')
	SET @errcnt = @errcnt + 1
END
				
PRINT 'T_LINEITEM '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_lineitem]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_lineitem
	FROM link.impresario_restore.dbo.t_lineitem a
		INNER JOIN PSS_ElliottMarketing.dbo.t_order b ON a.order_no = b.order_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_perf c ON a.perf_no = c.perf_no
		LEFT JOIN PSS_ElliottMarketing.dbo.t_pkg d ON a.pkg_no = d.pkg_no
	WHERE c.perf_no IS NOT NULL
		OR d.pkg_no IS NOT NULL

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_lineitem', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_lineitem', @reccnt)
	
		CREATE CLUSTERED INDEX t_lineitem_seq_no ON PSS_ElliottMarketing.dbo.t_lineitem (li_seq_no)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_lineitem', 'already exists')
	SET @errcnt = @errcnt + 1
END
	
PRINT 'T_SUB_LINEITEM'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_sub_lineitem]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_sub_lineitem
	FROM link.impresario_restore.dbo.t_sub_lineitem a
		INNER JOIN PSS_ElliottMarketing.dbo.t_lineitem b ON a.li_seq_no = b.li_seq_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_sub_lineitem', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_sub_lineitem', @reccnt)
	
		CREATE INDEX t_sub_lineitem_seat_no ON PSS_ElliottMarketing.dbo.t_sub_lineitem (seat_no)
		CREATE INDEX t_sub_lineitem_price_type ON PSS_ElliottMarketing.dbo.t_sub_lineitem (price_type)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_sub_lineitem', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_ORDER_SEAT_HIST '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_order_seat_hist]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_order_seat_hist
	FROM link.impresario_restore.dbo.t_order_seat_hist a
		INNER JOIN PSS_ElliottMarketing.dbo.t_order b ON a.order_no = b.order_no
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer c ON a.customer_no = c.customer_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_order_seat_hist', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_order_seat_hist', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_order_seat_hist', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_SEAT '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_seat]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_seat
	FROM link.impresario_restore.dbo.t_seat a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_sub_lineitem WHERE seat_no = a.seat_no)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_seat', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_seat', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_seat', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_MOS (pull based ON orders)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_mos]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_mos
	FROM link.impresario_restore.dbo.tr_mos a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_order WHERE mos = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_mos', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_mos', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_mos', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_MOS_CATEGORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_mos_category]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_mos_category
	FROM link.impresario_restore.dbo.tr_mos_category a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tr_mos WHERE category = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_mos_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_mos_category', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_mos_category', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PRICE_TYPE (pull based ON sub_lineitems)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_price_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_price_type
	FROM link.impresario_restore.dbo.tr_price_type a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_sub_lineitem WHERE price_type = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_price_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_price_type', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_price_type', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'TR_PRICE_TYPE_CATEGORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_price_type_category]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_price_type_category
	FROM link.impresario_restore.dbo.tr_price_type_category a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tr_price_type WHERE price_type_category = a.id)

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_price_type_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_price_type_category', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_price_type_category', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'T_AFFILIATION'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].t_affiliation') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_affiliation
	FROM link.impresario_restore.dbo.t_affiliation a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tx_const_cust WHERE customer_no = a.individual_customer_no)
		or EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.tx_const_cust WHERE customer_no = a.group_customer_no)
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_affiliation', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('t_affiliation', @reccnt)
	
		CREATE CLUSTERED INDEX t_affiliation_no ON PSS_ElliottMarketing.dbo.t_affiliation (affiliation_no)
		CREATE INDEX t_individual_customer_no ON PSS_ElliottMarketing.dbo.t_affiliation (individual_customer_no)
		CREATE INDEX t_group_customer_no ON PSS_ElliottMarketing.dbo.t_affiliation (group_customer_no)
		CREATE INDEX t_affiliation_type_id ON PSS_ElliottMarketing.dbo.t_affiliation (affiliation_type_id)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('t_affiliation', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_AFFILIATION_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].tr_affiliation_type') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_affiliation_type
	FROM link.impresario_restore.dbo.tr_affiliation_type a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_affiliation_type', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_affiliation_type', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_affiliation_type', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_RELATIONSHIP_CATEGORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].tr_relationship_category') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_relationship_category
	FROM link.impresario_restore.dbo.tr_relationship_category a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_relationship_category', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tr_relationship_category', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tr_relationship_category', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_PERF_PRICE_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].T_PERF_PRICE_TYPE') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.T_PERF_PRICE_TYPE
	FROM link.impresario_restore.dbo.T_PERF_PRICE_TYPE a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PERF_PRICE_TYPE', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('T_PERF_PRICE_TYPE', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PERF_PRICE_TYPE', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'T_PERF_PRICE_LAYER'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].T_PERF_PRICE_LAYER') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.T_PERF_PRICE_LAYER
	FROM link.impresario_restore.dbo.T_PERF_PRICE_LAYER a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PERF_PRICE_LAYER', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('T_PERF_PRICE_LAYER', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PERF_PRICE_LAYER', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_PRICE_LAYER_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].TR_PRICE_LAYER_TYPE') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.TR_PRICE_LAYER_TYPE
	FROM link.impresario_restore.dbo.TR_PRICE_LAYER_TYPE a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TR_PRICE_LAYER_TYPE', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('TR_PRICE_LAYER_TYPE', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TR_PRICE_LAYER_TYPE', 'already exists')
	SET @errcnt = @errcnt + 1
END

PRINT 'T_TICKET_HISTORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].T_TICKET_HISTORY') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.T_TICKET_HISTORY
	FROM link.impresario_restore.dbo.T_TICKET_HISTORY a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_TICKET_HISTORY', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('T_TICKET_HISTORY', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_TICKET_HISTORY', 'already exists')
	SET @errcnt = @errcnt + 1
END



PRINT 'T_PACKAGE_HISTORY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].T_PACKAGE_HISTORY') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.T_PACKAGE_HISTORY
	FROM link.impresario_restore.dbo.T_PACKAGE_HISTORY a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PACKAGE_HISTORY', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('T_PACKAGE_HISTORY', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('T_PACKAGE_HISTORY', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TX_CONTACT_POINT_PURPOSE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].TX_CONTACT_POINT_PURPOSE') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.TX_CONTACT_POINT_PURPOSE
	FROM link.impresario_restore.dbo.TX_CONTACT_POINT_PURPOSE a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TX_CONTACT_POINT_PURPOSE', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('TX_CONTACT_POINT_PURPOSE', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TX_CONTACT_POINT_PURPOSE', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TR_SLI_STATUS'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].TR_SLI_STATUS') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.TR_SLI_STATUS
	FROM link.impresario_restore.dbo.TR_SLI_STATUS a
	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TR_SLI_STATUS', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('TR_SLI_STATUS', @reccnt)

	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('TR_SLI_STATUS', 'already exists')
	SET @errcnt = @errcnt + 1
END


PRINT 'TX_CUST_KEYWORD'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_keyword]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_keyword
	FROM link.impresario_restore.dbo.tx_cust_keyword a
		INNER JOIN PSS_ElliottMarketing.dbo.t_keyword b ON a.keyword_no = b.keyword_no

	SELECT @errnum = @@ERROR,@reccnt = @@ROWCOUNT
	
	IF @errnum>0
	BEGIN
		select @errmsg = text from sys.messages where message_id = @errnum and language_id = 1033
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_keyword', @errmsg)
		SET @errcnt = @errcnt + 1
	END
	ELSE
	BEGIN
		INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, record_count) VALUES ('tx_cust_keyword', @reccnt)
	END
END
ELSE
BEGIN
	INSERT INTO PSS_ElliottMarketing.dbo.export_counts (table_name, error_msg) VALUES ('tx_cust_keyword', 'already exists')
	SET @errcnt = @errcnt + 1
END



INSERT INTO PSS_ElliottMarketing.dbo.export_log (process,result,control_groups) 
VALUES ('data exported', CASE WHEN @errcnt = 0 THEN 'success' ELSE 'failure - check export_counts table' END, @p_control_groups)

end

