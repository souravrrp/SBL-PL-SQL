--*************
select 
  *
  --count(*)
from TEMP_DIRECT_SALES_TAB t
where t.year = '&year_i' and
t.period = '&period' and
--t.order_no = 'HBJ-H2335' --and
T.ORDER_NO in ('NKP-H4311', 'SNG-H3546', 'CFC-H817', 'BSN-H4387', 'CML-H2770', 'DMB-H4293', 'KRL-H3187', 'BRB-H2081', 'DBL-H1255', 'JND-H1524', 'CCO-H1108', 'CTM-H4852', 'CHS-H4326', 'TON-H6232', 'DHB-H1327', 'FBG-H1183', 'FEN-H2468', 'CTS-H4708', 'CDH-H502', 'DGN-H4510', 'BSB-H3003', 'SDM-H3543')
--t.sales_part = 'SRGFT-SBL-JERSEY-014'

--*****
--delete from TEMP_DIRECT_SALES_TAB t;
--commit;

--truncate table ifsapp.temp_direct_sales_tab;


--*****No. of Cash Accounts & Sum of Cash Value with Positive HP Variations
select 
  --*
  count(*),
  sum(t.cash_units),
  sum(t.cash_value)
from TEMP_DIRECT_SALES_TAB t
where t.year = '&year_i' and
  t.period = '&period' and
  t.catalog_type != 'KOMP' AND
  substr(t.order_no,4,2) = '-R'
  
--*****No. of Hire Accounts & Sum of Hire Value
select 
  --*
  count(*),
  sum(t.hire_units),
  sum(t.net_hire_cash_value)
from TEMP_DIRECT_SALES_TAB t
where t.year = '&year_i' and
  t.period = '&period' and
  t.catalog_type != 'KOMP' AND
  substr(t.order_no,4,2) = '-H' and
  t.state not in ('Reverted', 'RevertReversed')


--*****No. of Revert Accounts & Sum of Revert Value
select 
  --*
  count(*),
  sum(t.reverts_units),
  sum(t.reverts_value)
from TEMP_DIRECT_SALES_TAB t
where t.year = '&year_i' and
  t.period = '&period' and
  t.catalog_type != 'KOMP' AND
  substr(t.order_no,4,2) = '-H' and
  t.state in ('Reverted')
  
--*****No. of Revert Reversed Accounts & Sum of Revert Reversed Value
select 
  --*
  count(*),
  sum(t.revert_reverse_units),
  sum(t.revert_reverse_value)
from TEMP_DIRECT_SALES_TAB t
where t.year = '&year_i' and
  t.period = '&period' and
  t.catalog_type != 'KOMP' AND
  substr(t.order_no,4,2) = '-H' and
  t.state in ('RevertReversed')


--************
select 
  *
  --count(*)
from HPNRET_DIRECT_SALES_TAB t
where t.year = '&year_i' and
t.period = '&period'

--************
--exec HPNRET_DIRECT_SALES_API.Shedule_Transfer(2014,12,'%');
--exec HPNRET_DIRECT_SALES_API.Transfer_New(2015,2,'%');
--exec HPNRET_DIRECT_SALES_API.Purge(2015,1,'%');


--************Our SBL Table
select 
  *
  --count(*) 
from SBL_DIRECT_SALES_DETAILS_TAB t
where t.year = '&year_i' and
t.period = '&period' --and
--t.order_no = 'DRS-H2410'
--T.ORDER_NO in ('NKP-H4311', 'SNG-H3546', 'CFC-H817', 'BSN-H4387', 'CML-H2770', 'DMB-H4293', 'KRL-H3187', 'BRB-H2081', 'DBL-H1255', 'JND-H1524', 'CCO-H1108', 'CTM-H4852', 'CHS-H4326', 'TON-H6232', 'DHB-H1327', 'FBG-H1183', 'FEN-H2468', 'CTS-H4708', 'CDH-H502', 'DGN-H4510', 'BSB-H3003', 'SDM-H3543')
--T.CASH_UNITS = 0 AND
--T.CASH_VALUE > 0
--t.order_no = 'SWS-R955'


--*****
--delete from SBL_DIRECT_SALES_DETAILS_TAB t
--where t.year = 2014 and t.period = 9;
--commit;


--***** No. of Cash Accounts & Sum of Cash Value with Positive HP Variations in SBL Table
select 
  --*
  count(*),
  sum(t.cash_units),
  sum(t.cash_value) 
from SBL_DIRECT_SALES_DETAILS_TAB t
where t.year = '&year_i' and
t.period = '&period' and
t.catalog_type != 'KOMP' AND
substr(t.order_no,4,2) = '-R'

--***** No. of Hire Accounts & Sum of Hire Value in SBL Table
select 
  --*
  count(*),
  sum(t.hire_units),
  sum(t.net_hire_cash_value)
from SBL_DIRECT_SALES_DETAILS_TAB t
where t.year = '&year_i' and
  t.period = '&period' and
  t.catalog_type != 'KOMP' AND
  substr(t.order_no,4,2) = '-H' and
  t.state not in ('Reverted', 'RevertReversed')
  

--***** No. of Revert Accounts in SBL Table
select 
  --*
  count(*),
  sum(t.reverts_units),
  sum(t.reverts_value)
from SBL_DIRECT_SALES_DETAILS_TAB t
where t.year = '&year_i' and
  t.period = '&period' and
  t.catalog_type != 'KOMP' AND
  substr(t.order_no,4,2) = '-H' and
  t.state in ('Reverted')
  

--***** No. of Revert Reversed Accounts in SBL Table
select 
  --*
  count(*),
  sum(t.revert_reverse_units),
  sum(t.revert_reverse_value)
from SBL_DIRECT_SALES_DETAILS_TAB t
where t.year = '&year_i' and
  t.period = '&period' and
  t.catalog_type != 'KOMP' AND
  substr(t.order_no,4,2) = '-H' and
  t.state in ('RevertReversed')

