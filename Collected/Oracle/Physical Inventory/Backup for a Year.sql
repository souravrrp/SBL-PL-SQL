--create backup of physical inventory count data for a year
/*
UPDATE SBL_INVENTORY_COUNTING_DTS t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_INVENT_COUNTING_DTS_HIST
  select * from ifsapp.SBL_INVENTORY_COUNTING_DTS;
commit;
*/
select * from SBL_INVENT_COUNTING_DTS_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_SALES_TEMP_FOR_INVENTORY t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_SALES_TEMP_FOR_INVENT_HIST
  SELECT * FROM SBL_SALES_TEMP_FOR_INVENTORY;
commit;
*/
select * from SBL_SALES_TEMP_FOR_INVENT_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_SEND_TEMP_FOR_INVENTORY t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_SEND_TEMP_FOR_INVENT_HIST
  select * from SBL_SEND_TEMP_FOR_INVENTORY;
commit;
*/
select * from SBL_SEND_TEMP_FOR_INVENT_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_CUT_OFF_FORM_TBL t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_CUT_OFF_FORM_HIST
  select * from SBL_CUT_OFF_FORM_TBL;
commit;
*/
select * from SBL_CUT_OFF_FORM_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_CUST_PROD_REPAIR_TAB t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_CUST_PROD_REPAIR_HIST
  select * from SBL_CUST_PROD_REPAIR_TAB;
commit;
*/
select * from SBL_CUST_PROD_REPAIR_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_UNCLAIM_REPAIR_PRO_TBL t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_UNCLAIM_REPAIR_PRO_HIST
  select * from SBL_UNCLAIM_REPAIR_PRO_TBL;
commit;
*/
select * from SBL_UNCLAIM_REPAIR_PRO_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_SOLD_NOT_DEL_TBL t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_SOLD_NOT_DEL_HIST
  select * from SBL_SOLD_NOT_DEL_TBL;
commit;
*/
select * from SBL_SOLD_NOT_DEL_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE REC_AFTER_CUT_OFF_TBL t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.REC_AFTER_CUT_OFF_HIST
  select * from REC_AFTER_CUT_OFF_TBL;
commit;
*/
select * from REC_AFTER_CUT_OFF_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_REVERT_ACCOUNT_TBL t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_REVERT_ACCOUNT_HIST
  select * from SBL_REVERT_ACCOUNT_TBL;
commit;
*/
select * from SBL_REVERT_ACCOUNT_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_SHOP_ARRPOVE_TBL t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_SHOP_ARRPOVE_HIST
  select * from SBL_SHOP_ARRPOVE_TBL;
commit;
*/
select * from SBL_SHOP_ARRPOVE_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_FIXED_ASSET_REGISTER_TAB t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_FIXED_ASSET_REGISTER_HIST
  select * from SBL_FIXED_ASSET_REGISTER_TAB;
commit;
*/
select * from SBL_FIXED_ASSET_REGISTER_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_WO_INFO_INVENTORY t SET T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_PI_WO_INFO_HIST
  select * from SBL_WO_INFO_INVENTORY;
commit;
*/
select * from SBL_PI_WO_INFO_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_PI_SHOP_STOCK_IN_FRANCHISE t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_PI_SHOP_STOCK_IN_FRNC_HIST
  select * from SBL_PI_SHOP_STOCK_IN_FRANCHISE;
commit;
*/
select * from SBL_PI_SHOP_STOCK_IN_FRNC_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

-- New
/*
UPDATE SBL_PI_FRANCHISE_INFO t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_PI_FRANCHISE_INFO_HIST
  select * from ifsapp.SBL_PI_FRANCHISE_INFO;
commit;
*/
select * from SBL_PI_FRANCHISE_INFO_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_PI_BANK_CARD_POS t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_PI_BANK_POS_HIST
  select * from SBL_PI_BANK_CARD_POS;
commit;
*/
select * from SBL_PI_BANK_POS_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

--
/*
UPDATE SBL_USER_LIST t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_USER_LIST_HIST
  select * from SBL_USER_LIST;
commit;
*/
select * from SBL_USER_LIST_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

-- New
/*
UPDATE SBL_PI_SHOP_GPS_INFO t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_PI_SHOP_GPS_INFO_HIST
  select * from SBL_PI_SHOP_GPS_INFO;
commit;
*/
select * from SBL_PI_SHOP_GPS_INFO_HIST t
where t.count_year = '&year'
and t.count_period = '&period';

-- New
/*
UPDATE SBL_PI_SO_APPROVER t SET T.COUNT_YEAR = '&year', T.COUNT_PERIOD = '&period';
COMMIT;
insert into ifsapp.SBL_PI_SO_APPROVER_HIST
  select * from SBL_PI_SO_APPROVER;
commit;
*/
select * from SBL_PI_SO_APPROVER_HIST t
where t.count_year = '&year'
and t.count_period = '&period';
