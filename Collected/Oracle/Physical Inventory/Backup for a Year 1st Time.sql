--create backup of physical inventory count data for a year
/*
create table ifsapp.SBL_INVENT_COUNTING_DTS_HIST
as (select * from ifsapp.SBL_INVENTORY_COUNTING_DTS);

--
create table ifsapp.SBL_SALES_TEMP_FOR_INVENT_HIST
as (SELECT * FROM SBL_SALES_TEMP_FOR_INVENTORY);

--
create table ifsapp.SBL_SEND_TEMP_FOR_INVENT_HIST
as (select * from SBL_SEND_TEMP_FOR_INVENTORY);

--
create table ifsapp.SBL_CUT_OFF_FORM_HIST
as (select * from SBL_CUT_OFF_FORM_TBL);

--
create table ifsapp.SBL_CUST_PROD_REPAIR_HIST
as (select * from SBL_CUST_PROD_REPAIR_TAB);

--
create table ifsapp.SBL_UNCLAIM_REPAIR_PRO_HIST
as (select * from SBL_UNCLAIM_REPAIR_PRO_TBL);

--
create table ifsapp.SBL_SOLD_NOT_DEL_HIST
as (select * from SBL_SOLD_NOT_DEL_TBL);

--
create table ifsapp.REC_AFTER_CUT_OFF_HIST
as (select * from REC_AFTER_CUT_OFF_TBL);

--
create table ifsapp.SBL_REVERT_ACCOUNT_HIST
as (select * from SBL_REVERT_ACCOUNT_TBL);

--
create table ifsapp.SBL_SHOP_ARRPOVE_HIST
as (select * from SBL_SHOP_ARRPOVE_TBL);

--
create table ifsapp.SBL_FIXED_ASSET_REGISTER_HIST
as (select * from SBL_FIXED_ASSET_REGISTER_TAB);

--
create table ifsapp.SBL_USER_LIST_HIST
as (select * from SBL_USER_LIST);

--
create table ifsapp.SBL_PI_WO_INFO_HIST
as (select * from ifsapp.SBL_WO_INFO_INVENTORY);

--
create table ifsapp.SBL_PI_SHOP_STOCK_IN_FRNC_HIST
as (select * from ifsapp.SBL_PI_SHOP_STOCK_IN_FRANCHISE);

-- New
create table ifsapp.SBL_PI_FRANCHISE_INFO_HIST
as (select * from ifsapp.SBL_PI_FRANCHISE_INFO);

--
create table ifsapp.SBL_PI_BANK_POS_HIST
as (select * from ifsapp.SBL_PI_BANK_CARD_POS);

-- New
create table ifsapp.SBL_PI_SO_APPROVER_HIST
as (select * from ifsapp.SBL_PI_SO_APPROVER);

-- New
create table ifsapp.SBL_PI_SHOP_GPS_INFO_HIST
as (select * from ifsapp.SBL_PI_SHOP_GPS_INFO);
*/
