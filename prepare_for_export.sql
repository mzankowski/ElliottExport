CREATE PROCEDURE [dbo].[prepare_for_export] AS
BEGIN
--USE PSS_ElliottMarketing
/*
--added tr_section 08/06/12 by Mijala
	added t_affiliation, tr_affiliation_type, tr_relationship_category 11/07/12 by Mijala

	03/04/15 by Mijala
		added tr_sli_status
	07/23/15 BY Mijala
		added tx_cust_keyword
*/
--dbo_T_APPEAL 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_appeal]') AND type in (N'U'))
	DROP TABLE dbo.t_appeal

--dbo_T_CAMPAIGN 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_campaign]') AND type in (N'U'))
	DROP TABLE  dbo.t_campaign

--dbo_TR_CAMPAIGN_CATEGORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_campaign_category]') AND type in (N'U'))
	DROP TABLE  dbo.tr_campaign_category

--dbo_T_FACILITY 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_facility]') AND type in (N'U')) 
	DROP TABLE dbo.t_Facility

--dbo_T_FUND 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_fund]') AND type in (N'U')) 
	DROP TABLE dbo.t_fund

--dbo_T_INVENTORY 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_inventory]') AND type in (N'U')) 
	DROP TABLE dbo.t_inventory

--dbo_T_KEYWORD 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_keyword]') AND type in (N'U')) 
	DROP TABLE dbo.t_keyword

--dbo_T_KWCODED_VALUES 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_kwcoded_values]') AND type in (N'U')) 
	DROP TABLE dbo.t_kwcoded_values

--dbo_T_PERF 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_perf]') AND type in (N'U')) 
	DROP TABLE dbo.t_perf

--dbo_T_PKG 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_pkg]') AND type in (N'U')) 
	DROP TABLE dbo.t_pkg

--dbo_T_PROD_SEASON 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_prod_season]') AND type in (N'U')) 
	DROP TABLE dbo.t_Prod_season

--dbo_T_PRODUCTION 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_production]') AND type in (N'U')) 
	DROP TABLE dbo.t_production

--dbo_T_TITLE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_title]') AND type in (N'U')) 
	DROP TABLE dbo.t_title

--dbo_TR_ADDRESS_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_address_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_address_type

--dbo_TR_Appeal_Category
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_appeal_category]') AND type in (N'U')) 
	DROP TABLE dbo.tr_appeal_category

--dbo_TR_CONSTITUENCY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_constituency]') AND type in (N'U')) 
	DROP TABLE dbo.tr_constituency

--dbo_TR_CUST_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_cust_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_cust_type

--dbo_TR_MOS
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_mos]') AND type in (N'U')) 
	DROP TABLE dbo.tr_mos

--dbo_TR_MOS_CATEGORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_mos_category]') AND type in (N'U')) 
	DROP TABLE dbo.tr_mos_category

--dbo_TR_PERF_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_perf_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_perf_type

--dbo_TR_PHONE_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_phone_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_phone_type

--dbo_TR_PKG_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_pkg_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_pkg_type

--dbo_TR_PREFIX
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_prefix]') AND type in (N'U')) 
	DROP TABLE dbo.tr_prefix

--dbo_TR_PRICE_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_price_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_price_type

--dbo_TR_PRICE_TYPE_CATEGORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_price_type_category]') AND type in (N'U')) 
	DROP TABLE dbo.tr_price_type_category

--dbo_TR_RANK_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_rank_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_rank_type

--dbo_TX_APPEAL_MEDIA_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_appeal_media_type]') AND type in (N'U')) 
	DROP TABLE dbo.tx_appeal_media_type

--dbo_TX_CAMP_FUND
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_camp_fund]') AND type in (N'U')) 
	DROP TABLE dbo.tx_camp_fund

--dbo_TR_SEASON
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_season]') AND type in (N'U')) 
	DROP TABLE dbo.tr_season

--dbo_TR_SEASON_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_season_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_season_type

--dbo_TR_SUFFIX
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_suffix]') AND type in (N'U')) 
	DROP TABLE dbo.tr_suffix

--dbo_T_CUSTOMER 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_customer]') AND type in (N'U')) 
	DROP TABLE dbo.t_customer

--dbo_T_ADDRESS 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_address]') AND type in (N'U')) 
	DROP TABLE dbo.t_address

--dbo_TX_CUST_SAL
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_sal]') AND type in (N'U')) 
	DROP TABLE dbo.tx_cust_sal

--dbo_T_EADDRESS 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_eaddress]') AND type in (N'U')) 
	DROP TABLE dbo.t_eaddress

--dbo_T_PHONE 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_phone]') AND type in (N'U')) 
	DROP TABLE dbo.t_phone

--dbo_T_CUST_RANK 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_rank]') AND type in (N'U')) 
	DROP TABLE dbo.t_cust_rank

--dbo_T_PROMOTION 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_promotion]') AND type in (N'U')) 
	DROP TABLE dbo.t_promotion

--dbo_TX_CONST_CUST
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_const_cust]') AND type in (N'U')) 
	DROP TABLE dbo.tx_const_cust

--dbo_TX_CUST_TKW
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_tkw]') AND type in (N'U')) 
	DROP TABLE dbo.tx_cust_tkw

--dbo_T_CONTRIBUTION 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_contribution]') AND type in (N'U')) 
	DROP TABLE dbo.t_contribution

--dbo_T_CREDITEE 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_creditee]') AND type in (N'U')) 
	DROP TABLE dbo.t_creditee

--dbo_T_SCHEDULE 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_schedule]') AND type in (N'U')) 
	DROP TABLE dbo.t_schedule

--dbo_TR_SECTION 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_section]') AND type in (N'U')) 
	DROP TABLE dbo.tr_section

--dbo_T_CUST_SUBSCRIPTION_SUMMARY 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_subscription_summary]') AND type in (N'U')) 
	DROP TABLE dbo.t_cust_subscription_summary

--dbo_LT_SUBSCRIPTION_HIST
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lt_subscription_hist]') AND type in (N'U')) 
	DROP TABLE dbo.lt_subscription_hist

--dbo_T_TCK_HIST
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lt_tck_hist]') AND type in (N'U')) 
	DROP TABLE dbo.lt_tck_hist

--dbo_T_ORDER 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_order]') AND type in (N'U')) 
	DROP TABLE dbo.t_order

--dbo_T_LINEITEM 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_lineitem]') AND type in (N'U')) 
	DROP TABLE dbo.t_lineitem

--dbo_T_ORDER_SEAT_HIST 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_order_seat_hist]') AND type in (N'U')) 
	DROP TABLE dbo.t_order_seat_hist

--dbo_T_SEAT 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_seat]') AND type in (N'U')) 
	DROP TABLE dbo.t_seat

--dbo_T_SUB_LINEITEM
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_sub_lineitem]') AND type in (N'U')) 
	DROP TABLE dbo.t_sub_lineitem

--dbo_T_AFFILIATION
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_affiliation]') AND type in (N'U')) 
	DROP TABLE dbo.t_affiliation

--dbo_TR_AFFILIATION_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_affiliation_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_affiliation_type

--dbo_TR_RELATIONSHIP_CATEGORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_relationship_category]') AND type in (N'U')) 
	DROP TABLE dbo.tr_relationship_category

--/* need to take comment out once in V12 by Mijala
--dbo_T_PERF_PRICE_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_PERF_PRICE_TYPE]') AND type in (N'U')) 
	DROP TABLE dbo.T_PERF_PRICE_TYPE

--T_PERF_PRICE_LAYER
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_PERF_PRICE_LAYER]') AND type in (N'U')) 
	DROP TABLE dbo.T_PERF_PRICE_LAYER

--TR_PRICE_LAYER_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_PRICE_LAYER_TYPE]') AND type in (N'U')) 
	DROP TABLE dbo.TR_PRICE_LAYER_TYPE

--T_TICKET_HISTORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_TICKET_HISTORY]') AND type in (N'U')) 
	DROP TABLE dbo.T_TICKET_HISTORY
	
--T_PACKAGE_HISTORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_PACKAGE_HISTORY]') AND type in (N'U')) 
	DROP TABLE dbo.T_PACKAGE_HISTORY

--TX_CONTACT_POINT_PURPOSE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TX_CONTACT_POINT_PURPOSE]') AND type in (N'U')) 
	DROP TABLE dbo.TX_CONTACT_POINT_PURPOSE

--TR_SLI_STATUS
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SLI_STATUS]') AND type in (N'U')) 
	DROP TABLE dbo.TR_SLI_STATUS

--TX_CUST_KEYWORD
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_keyword]') AND type in (N'U')) 
	DROP TABLE dbo.tx_cust_keyword
--*/

INSERT INTO export_log (process,result) VALUES ('table drops', 'success')
END

CREATE PROCEDURE [dbo].[prepare_for_export] AS
BEGIN
--USE PSS_ElliottMarketing
/*
--added tr_section 08/06/12 by Mijala
	added t_affiliation, tr_affiliation_type, tr_relationship_category 11/07/12 by Mijala

	03/04/15 by Mijala
		added tr_sli_status
	07/23/15 BY Mijala
		added tx_cust_keyword
*/
--dbo_T_APPEAL 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_appeal]') AND type in (N'U'))
	DROP TABLE dbo.t_appeal

--dbo_T_CAMPAIGN 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_campaign]') AND type in (N'U'))
	DROP TABLE  dbo.t_campaign

--dbo_TR_CAMPAIGN_CATEGORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_campaign_category]') AND type in (N'U'))
	DROP TABLE  dbo.tr_campaign_category

--dbo_T_FACILITY 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_facility]') AND type in (N'U')) 
	DROP TABLE dbo.t_Facility

--dbo_T_FUND 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_fund]') AND type in (N'U')) 
	DROP TABLE dbo.t_fund

--dbo_T_INVENTORY 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_inventory]') AND type in (N'U')) 
	DROP TABLE dbo.t_inventory

--dbo_T_KEYWORD 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_keyword]') AND type in (N'U')) 
	DROP TABLE dbo.t_keyword

--dbo_T_KWCODED_VALUES 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_kwcoded_values]') AND type in (N'U')) 
	DROP TABLE dbo.t_kwcoded_values

--dbo_T_PERF 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_perf]') AND type in (N'U')) 
	DROP TABLE dbo.t_perf

--dbo_T_PKG 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_pkg]') AND type in (N'U')) 
	DROP TABLE dbo.t_pkg

--dbo_T_PROD_SEASON 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_prod_season]') AND type in (N'U')) 
	DROP TABLE dbo.t_Prod_season

--dbo_T_PRODUCTION 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_production]') AND type in (N'U')) 
	DROP TABLE dbo.t_production

--dbo_T_TITLE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_title]') AND type in (N'U')) 
	DROP TABLE dbo.t_title

--dbo_TR_ADDRESS_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_address_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_address_type

--dbo_TR_Appeal_Category
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_appeal_category]') AND type in (N'U')) 
	DROP TABLE dbo.tr_appeal_category

--dbo_TR_CONSTITUENCY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_constituency]') AND type in (N'U')) 
	DROP TABLE dbo.tr_constituency

--dbo_TR_CUST_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_cust_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_cust_type

--dbo_TR_MOS
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_mos]') AND type in (N'U')) 
	DROP TABLE dbo.tr_mos

--dbo_TR_MOS_CATEGORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_mos_category]') AND type in (N'U')) 
	DROP TABLE dbo.tr_mos_category

--dbo_TR_PERF_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_perf_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_perf_type

--dbo_TR_PHONE_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_phone_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_phone_type

--dbo_TR_PKG_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_pkg_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_pkg_type

--dbo_TR_PREFIX
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_prefix]') AND type in (N'U')) 
	DROP TABLE dbo.tr_prefix

--dbo_TR_PRICE_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_price_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_price_type

--dbo_TR_PRICE_TYPE_CATEGORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_price_type_category]') AND type in (N'U')) 
	DROP TABLE dbo.tr_price_type_category

--dbo_TR_RANK_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_rank_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_rank_type

--dbo_TX_APPEAL_MEDIA_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_appeal_media_type]') AND type in (N'U')) 
	DROP TABLE dbo.tx_appeal_media_type

--dbo_TX_CAMP_FUND
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_camp_fund]') AND type in (N'U')) 
	DROP TABLE dbo.tx_camp_fund

--dbo_TR_SEASON
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_season]') AND type in (N'U')) 
	DROP TABLE dbo.tr_season

--dbo_TR_SEASON_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_season_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_season_type

--dbo_TR_SUFFIX
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_suffix]') AND type in (N'U')) 
	DROP TABLE dbo.tr_suffix

--dbo_T_CUSTOMER 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_customer]') AND type in (N'U')) 
	DROP TABLE dbo.t_customer

--dbo_T_ADDRESS 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_address]') AND type in (N'U')) 
	DROP TABLE dbo.t_address

--dbo_TX_CUST_SAL
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_sal]') AND type in (N'U')) 
	DROP TABLE dbo.tx_cust_sal

--dbo_T_EADDRESS 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_eaddress]') AND type in (N'U')) 
	DROP TABLE dbo.t_eaddress

--dbo_T_PHONE 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_phone]') AND type in (N'U')) 
	DROP TABLE dbo.t_phone

--dbo_T_CUST_RANK 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_rank]') AND type in (N'U')) 
	DROP TABLE dbo.t_cust_rank

--dbo_T_PROMOTION 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_promotion]') AND type in (N'U')) 
	DROP TABLE dbo.t_promotion

--dbo_TX_CONST_CUST
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_const_cust]') AND type in (N'U')) 
	DROP TABLE dbo.tx_const_cust

--dbo_TX_CUST_TKW
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_tkw]') AND type in (N'U')) 
	DROP TABLE dbo.tx_cust_tkw

--dbo_T_CONTRIBUTION 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_contribution]') AND type in (N'U')) 
	DROP TABLE dbo.t_contribution

--dbo_T_CREDITEE 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_creditee]') AND type in (N'U')) 
	DROP TABLE dbo.t_creditee

--dbo_T_SCHEDULE 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_schedule]') AND type in (N'U')) 
	DROP TABLE dbo.t_schedule

--dbo_TR_SECTION 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_section]') AND type in (N'U')) 
	DROP TABLE dbo.tr_section

--dbo_T_CUST_SUBSCRIPTION_SUMMARY 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_subscription_summary]') AND type in (N'U')) 
	DROP TABLE dbo.t_cust_subscription_summary

--dbo_LT_SUBSCRIPTION_HIST
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lt_subscription_hist]') AND type in (N'U')) 
	DROP TABLE dbo.lt_subscription_hist

--dbo_T_TCK_HIST
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lt_tck_hist]') AND type in (N'U')) 
	DROP TABLE dbo.lt_tck_hist

--dbo_T_ORDER 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_order]') AND type in (N'U')) 
	DROP TABLE dbo.t_order

--dbo_T_LINEITEM 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_lineitem]') AND type in (N'U')) 
	DROP TABLE dbo.t_lineitem

--dbo_T_ORDER_SEAT_HIST 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_order_seat_hist]') AND type in (N'U')) 
	DROP TABLE dbo.t_order_seat_hist

--dbo_T_SEAT 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_seat]') AND type in (N'U')) 
	DROP TABLE dbo.t_seat

--dbo_T_SUB_LINEITEM
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_sub_lineitem]') AND type in (N'U')) 
	DROP TABLE dbo.t_sub_lineitem

--dbo_T_AFFILIATION
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_affiliation]') AND type in (N'U')) 
	DROP TABLE dbo.t_affiliation

--dbo_TR_AFFILIATION_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_affiliation_type]') AND type in (N'U')) 
	DROP TABLE dbo.tr_affiliation_type

--dbo_TR_RELATIONSHIP_CATEGORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tr_relationship_category]') AND type in (N'U')) 
	DROP TABLE dbo.tr_relationship_category

--/* need to take comment out once in V12 by Mijala
--dbo_T_PERF_PRICE_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_PERF_PRICE_TYPE]') AND type in (N'U')) 
	DROP TABLE dbo.T_PERF_PRICE_TYPE

--T_PERF_PRICE_LAYER
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_PERF_PRICE_LAYER]') AND type in (N'U')) 
	DROP TABLE dbo.T_PERF_PRICE_LAYER

--TR_PRICE_LAYER_TYPE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_PRICE_LAYER_TYPE]') AND type in (N'U')) 
	DROP TABLE dbo.TR_PRICE_LAYER_TYPE

--T_TICKET_HISTORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_TICKET_HISTORY]') AND type in (N'U')) 
	DROP TABLE dbo.T_TICKET_HISTORY
	
--T_PACKAGE_HISTORY
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_PACKAGE_HISTORY]') AND type in (N'U')) 
	DROP TABLE dbo.T_PACKAGE_HISTORY

--TX_CONTACT_POINT_PURPOSE
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TX_CONTACT_POINT_PURPOSE]') AND type in (N'U')) 
	DROP TABLE dbo.TX_CONTACT_POINT_PURPOSE

--TR_SLI_STATUS
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SLI_STATUS]') AND type in (N'U')) 
	DROP TABLE dbo.TR_SLI_STATUS

--TX_CUST_KEYWORD
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tx_cust_keyword]') AND type in (N'U')) 
	DROP TABLE dbo.tx_cust_keyword
--*/

INSERT INTO export_log (process,result) VALUES ('table drops', 'success')
END

