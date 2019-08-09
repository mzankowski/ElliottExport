CREATE proc [dbo].[run_elliotMkt_data]
(@org char(3))
as

DECLARE @RC int

DECLARE @p_control_groups varchar(100)

-- TODO: Set parameter values here.

 If @org ='POA'
 set @p_control_groups = '1,3,14'
 ELSE IF @ORG = 'POP'
 set @p_control_groups = '16,17,18,21,22'


EXECUTE @RC = [PSS_ElliottMarketing].[dbo].[prepare_for_export] 

EXECUTE @RC = [PSS_ElliottMarketing].[dbo].[export_to_elliottmarketing]  @p_control_groups


CREATE proc [dbo].[run_elliotMkt_data]
(@org char(3))
as

DECLARE @RC int

DECLARE @p_control_groups varchar(100)

-- TODO: Set parameter values here.

 If @org ='POA'
 set @p_control_groups = '1,3,14'
 ELSE IF @ORG = 'POP'
 set @p_control_groups = '16,17,18,21,22'


EXECUTE @RC = [PSS_ElliottMarketing].[dbo].[prepare_for_export] 

EXECUTE @RC = [PSS_ElliottMarketing].[dbo].[export_to_elliottmarketing]  @p_control_groups


