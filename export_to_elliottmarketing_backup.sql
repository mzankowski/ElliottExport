CREATE procedure [dbo].[export_to_elliottmarketing_backup] (@p_control_groups varchar(100)) as
begin

--declare @p_control_groups varchar(100)
--set @p_control_groups = '10,11,15'

DECLARE @errcnt INT, @errmsg nvarchar(1000), @reccnt INT, @errnum INT
SET @errcnt = 0

--USE PSS_ElliottMarketing

SET NOCOUNT ON
--select * from NAVI.impresario.dbo.tr_control_group

TRUNCATE TABLE PSS_ElliottMarketing.dbo.export_counts

PRINT 'T_FUND '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_fund]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_fund
	FROM NAVI.impresario.dbo.t_fund
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

PRINT 'T_CAMPAIGN '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_campaign]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_campaign
	FROM NAVI.impresario.dbo.t_campaign
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

/*
PRINT 'TX_CAMP_FUND'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_camp_fund]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_camp_fund
	FROM NAVI.impresario.dbo.tx_camp_fund a
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
	FROM NAVI.impresario.dbo.t_appeal
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
	FROM NAVI.impresario.dbo.tr_appeal_category a
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
	FROM NAVI.impresario.dbo.tx_appeal_media_type a
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
	FROM NAVI.impresario.dbo.t_facility
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
	FROM NAVI.impresario.dbo.tr_season
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
	FROM NAVI.impresario.dbo.tr_season_type a
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
	FROM NAVI.impresario.dbo.t_prod_season a
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
	FROM NAVI.impresario.dbo.t_production a
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
	FROM NAVI.impresario.dbo.t_perf a
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
	FROM NAVI.impresario.dbo.tr_perf_type a
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
	FROM NAVI.impresario.dbo.t_pkg a
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
	FROM NAVI.impresario.dbo.tr_pkg_type a
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
	FROM NAVI.impresario.dbo.t_title a
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
	FROM NAVI.impresario.dbo.t_inventory a
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
	
PRINT 'T_KEYWORD '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_keyword]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_keyword
	FROM NAVI.impresario.dbo.t_keyword a
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
	FROM NAVI.impresario.dbo.t_kwcoded_values a
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
	FROM NAVI.impresario.dbo.tr_address_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR control_group IS NULL

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

PRINT 'TR_CONSTITUENCY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_constituency]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_constituency
	FROM NAVI.impresario.dbo.tr_constituency a
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

PRINT 'TR_PHONE_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_phone_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_phone_type
	FROM NAVI.impresario.dbo.tr_phone_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR control_group IS NULL

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

PRINT 'TR_RANK_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_rank_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_rank_type
	FROM NAVI.impresario.dbo.tr_rank_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR control_group IS NULL

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

PRINT 'TX_CONST_CUST'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_const_cust]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_const_cust
	FROM NAVI.impresario.dbo.tx_const_cust a
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
	FROM NAVI.impresario.dbo.t_customer a
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

PRINT 'TR_CUST_TYPE (pull based ON t_customer)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_cust_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_cust_type
	FROM NAVI.impresario.dbo.tr_cust_type a
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
	FROM NAVI.impresario.dbo.tr_prefix a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where prefix = a.id)
		OR EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where prefix2 = a.id)

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
	FROM NAVI.impresario.dbo.tr_suffix a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where suffix = a.id)
		OR EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where suffix2 = a.id)

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

PRINT 'T_ADDRESS '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_address]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_address
	FROM NAVI.impresario.dbo.t_address a
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
	
PRINT 'TX_CUST_SAL'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_sal]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_sal
	FROM NAVI.impresario.dbo.tx_cust_sal a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM NAVI.impresario.dbo.tr_signor WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.signor = c.id
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
	
PRINT 'T_EADDRESS '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_eaddress]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_eaddress 
	FROM NAVI.impresario.dbo.t_eaddress a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM NAVI.impresario.dbo.tr_eaddress_type WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.eaddress_type = c.id
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

PRINT 'T_PHONE '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_phone]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_phone 
	FROM NAVI.impresario.dbo.t_phone a
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
	FROM NAVI.impresario.dbo.t_cust_rank a
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
	
PRINT 'T_PROMOTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_promotion]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_promotion
	FROM NAVI.impresario.dbo.t_promotion a
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

PRINT 'TX_CUST_TKW'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_tkw]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_tkw 
	FROM NAVI.impresario.dbo.tx_cust_tkw a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN (SELECT * FROM NAVI.impresario.dbo.tr_tkw WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.tkw = c.id

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
	FROM NAVI.impresario.dbo.t_contribution a
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
	FROM NAVI.impresario.dbo.t_creditee a
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
	FROM NAVI.impresario.dbo.t_schedule a
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

PRINT 'T_CUST_SUBSCRIPTION_SUMMARY '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_subscription_summary]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_cust_subscription_summary
	FROM NAVI.impresario.dbo.t_cust_subscription_summary a
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
	FROM NAVI.impresario.dbo.lt_subscription_hist a
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
	FROM NAVI.impresario.dbo.lt_tck_hist a
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
	FROM NAVI.impresario.dbo.t_order a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
	WHERE EXISTS (SELECT 1 FROM NAVI.impresario.dbo.t_lineitem c 
					INNER JOIN PSS_ElliottMarketing.dbo.t_perf d ON c.perf_no = d.perf_no
					WHERE c.order_no = a.order_no)
		OR EXISTS (SELECT 1 FROM NAVI.impresario.dbo.t_lineitem e
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
	FROM NAVI.impresario.dbo.t_lineitem a
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
	FROM NAVI.impresario.dbo.t_sub_lineitem a
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
	FROM NAVI.impresario.dbo.t_order_seat_hist a
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
	FROM NAVI.impresario.dbo.t_seat a
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
	FROM NAVI.impresario.dbo.tr_mos a
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
	FROM NAVI.impresario.dbo.tr_mos_category a
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
	FROM NAVI.impresario.dbo.tr_price_type a
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
	FROM NAVI.impresario.dbo.tr_price_type_category a
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

INSERT INTO PSS_ElliottMarketing.dbo.export_log (process,result,control_groups) 
VALUES ('data exported', CASE WHEN @errcnt = 0 THEN 'success' ELSE 'failure - check export_counts table' END, @p_control_groups)
*/
end

CREATE procedure [dbo].[export_to_elliottmarketing_backup] (@p_control_groups varchar(100)) as
begin

--declare @p_control_groups varchar(100)
--set @p_control_groups = '10,11,15'

DECLARE @errcnt INT, @errmsg nvarchar(1000), @reccnt INT, @errnum INT
SET @errcnt = 0

--USE PSS_ElliottMarketing

SET NOCOUNT ON
--select * from NAVI.impresario.dbo.tr_control_group

TRUNCATE TABLE PSS_ElliottMarketing.dbo.export_counts

PRINT 'T_FUND '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_fund]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_fund
	FROM NAVI.impresario.dbo.t_fund
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

PRINT 'T_CAMPAIGN '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_campaign]') AND type in (N'U')) 
BEGIN
	SELECT *
	INTO PSS_ElliottMarketing.dbo.t_campaign
	FROM NAVI.impresario.dbo.t_campaign
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

/*
PRINT 'TX_CAMP_FUND'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_camp_fund]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_camp_fund
	FROM NAVI.impresario.dbo.tx_camp_fund a
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
	FROM NAVI.impresario.dbo.t_appeal
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
	FROM NAVI.impresario.dbo.tr_appeal_category a
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
	FROM NAVI.impresario.dbo.tx_appeal_media_type a
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
	FROM NAVI.impresario.dbo.t_facility
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
	FROM NAVI.impresario.dbo.tr_season
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
	FROM NAVI.impresario.dbo.tr_season_type a
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
	FROM NAVI.impresario.dbo.t_prod_season a
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
	FROM NAVI.impresario.dbo.t_production a
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
	FROM NAVI.impresario.dbo.t_perf a
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
	FROM NAVI.impresario.dbo.tr_perf_type a
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
	FROM NAVI.impresario.dbo.t_pkg a
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
	FROM NAVI.impresario.dbo.tr_pkg_type a
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
	FROM NAVI.impresario.dbo.t_title a
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
	FROM NAVI.impresario.dbo.t_inventory a
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
	
PRINT 'T_KEYWORD '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_keyword]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_keyword
	FROM NAVI.impresario.dbo.t_keyword a
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
	FROM NAVI.impresario.dbo.t_kwcoded_values a
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
	FROM NAVI.impresario.dbo.tr_address_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR control_group IS NULL

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

PRINT 'TR_CONSTITUENCY'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_constituency]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_constituency
	FROM NAVI.impresario.dbo.tr_constituency a
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

PRINT 'TR_PHONE_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_phone_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_phone_type
	FROM NAVI.impresario.dbo.tr_phone_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR control_group IS NULL

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

PRINT 'TR_RANK_TYPE'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_rank_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_rank_type
	FROM NAVI.impresario.dbo.tr_rank_type a
	WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0
		OR control_group IS NULL

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

PRINT 'TX_CONST_CUST'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_const_cust]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_const_cust
	FROM NAVI.impresario.dbo.tx_const_cust a
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
	FROM NAVI.impresario.dbo.t_customer a
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

PRINT 'TR_CUST_TYPE (pull based ON t_customer)'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_cust_type]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tr_cust_type
	FROM NAVI.impresario.dbo.tr_cust_type a
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
	FROM NAVI.impresario.dbo.tr_prefix a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where prefix = a.id)
		OR EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where prefix2 = a.id)

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
	FROM NAVI.impresario.dbo.tr_suffix a
	WHERE EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where suffix = a.id)
		OR EXISTS (SELECT 1 FROM PSS_ElliottMarketing.dbo.t_customer where suffix2 = a.id)

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

PRINT 'T_ADDRESS '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_address]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_address
	FROM NAVI.impresario.dbo.t_address a
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
	
PRINT 'TX_CUST_SAL'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_sal]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_sal
	FROM NAVI.impresario.dbo.tx_cust_sal a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM NAVI.impresario.dbo.tr_signor WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.signor = c.id
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
	
PRINT 'T_EADDRESS '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_eaddress]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_eaddress 
	FROM NAVI.impresario.dbo.t_eaddress a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		LEFT JOIN (SELECT * FROM NAVI.impresario.dbo.tr_eaddress_type WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.eaddress_type = c.id
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

PRINT 'T_PHONE '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_phone]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_phone 
	FROM NAVI.impresario.dbo.t_phone a
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
	FROM NAVI.impresario.dbo.t_cust_rank a
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
	
PRINT 'T_PROMOTION '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_promotion]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_promotion
	FROM NAVI.impresario.dbo.t_promotion a
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

PRINT 'TX_CUST_TKW'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_tkw]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.tx_cust_tkw 
	FROM NAVI.impresario.dbo.tx_cust_tkw a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
		INNER JOIN (SELECT * FROM NAVI.impresario.dbo.tr_tkw WHERE CHARINDEX(','+CAST(control_group AS VARCHAR)+',',','+@p_control_groups+',')>0) c ON a.tkw = c.id

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
	FROM NAVI.impresario.dbo.t_contribution a
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
	FROM NAVI.impresario.dbo.t_creditee a
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
	FROM NAVI.impresario.dbo.t_schedule a
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

PRINT 'T_CUST_SUBSCRIPTION_SUMMARY '
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_subscription_summary]') AND type in (N'U')) 
BEGIN
	SELECT a.*
	INTO PSS_ElliottMarketing.dbo.t_cust_subscription_summary
	FROM NAVI.impresario.dbo.t_cust_subscription_summary a
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
	FROM NAVI.impresario.dbo.lt_subscription_hist a
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
	FROM NAVI.impresario.dbo.lt_tck_hist a
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
	FROM NAVI.impresario.dbo.t_order a
		INNER JOIN PSS_ElliottMarketing.dbo.t_customer b ON a.customer_no = b.customer_no
	WHERE EXISTS (SELECT 1 FROM NAVI.impresario.dbo.t_lineitem c 
					INNER JOIN PSS_ElliottMarketing.dbo.t_perf d ON c.perf_no = d.perf_no
					WHERE c.order_no = a.order_no)
		OR EXISTS (SELECT 1 FROM NAVI.impresario.dbo.t_lineitem e
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
	FROM NAVI.impresario.dbo.t_lineitem a
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
	FROM NAVI.impresario.dbo.t_sub_lineitem a
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
	FROM NAVI.impresario.dbo.t_order_seat_hist a
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
	FROM NAVI.impresario.dbo.t_seat a
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
	FROM NAVI.impresario.dbo.tr_mos a
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
	FROM NAVI.impresario.dbo.tr_mos_category a
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
	FROM NAVI.impresario.dbo.tr_price_type a
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
	FROM NAVI.impresario.dbo.tr_price_type_category a
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

INSERT INTO PSS_ElliottMarketing.dbo.export_log (process,result,control_groups) 
VALUES ('data exported', CASE WHEN @errcnt = 0 THEN 'success' ELSE 'failure - check export_counts table' END, @p_control_groups)
*/
end

