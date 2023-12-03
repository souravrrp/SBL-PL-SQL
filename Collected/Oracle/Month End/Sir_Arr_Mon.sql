--***** Test
select h.year,
       h.period,
       h.acct_no,
       h.product_code,
       h.del_mon,
       h.act_out_bal,
       h.actual_ucc
--sum(h.act_out_bal - h.actual_ucc) NET--,
--sum(h.present_value) NET2
  from HPNRET_FORM249_ARREARS_TAB H
 where h.year = '&year_i'
   and h.period = '&period_i'
   and h.arr_mon >= 9
   and H.Act_Out_Bal > 0
   and h.product_code like '%SRMC%'
--group by h.year, h.period

--***** Start swh data
--NO. of 9 & 9+ Arr_Mon Accounts, Act_Out_Bal, Actual_UCC
select h.year,
       h.period,
       count(h.acct_no) acct_no,
       sum(h.act_out_bal) act_out_bal,
       sum(h.actual_ucc) actual_ucc
  from HPNRET_FORM249_ARREARS_TAB H
 where h.year = '&year_i'
   and h.period = '&period_i'
   and h.arr_mon >= 9
   and H.Act_Out_Bal > 0
   and h.shop_code not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and h.shop_code not in ('SAPM', 'SCOM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   /*and h.acct_no != 'DBL-H2291'*/
 group by h.year, h.period

--NO. of Motor Cycle 9 & 9+ Arr_Mon Accounts, Act_Out_Bal, Actual_UCC
select h.year,
       h.period,
       count(h.acct_no) acct_no,
       sum(h.act_out_bal) act_out_bal,
       sum(h.actual_ucc) actual_ucc
  from HPNRET_FORM249_ARREARS_TAB H
 where h.year = '&year_i'
   and h.period = '&period_i'
   and h.arr_mon >= 9
   and H.Act_Out_Bal > 0
   and h.product_code like '%SRMC%'
   and h.shop_code not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and h.shop_code not in ('SAPM', 'SCOM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
 group by h.year, h.period

--Total no. of active accounts
select h.year, h.period, count(h.acct_no) acct_no --,
--h.act_out_bal
  from HPNRET_FORM249_ARREARS_TAB H
 where h.year = '&year_i'
   and h.period = '&period_i'
   and h.act_out_bal > 0
   and h.shop_code not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and h.shop_code not in ('SAPM', 'SCOM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   /*and h.acct_no != 'DBL-H2291'*/
 group by h.year, h.period

-- Total Arrear Amount
select h.year,
       h.period,
       --h.acct_no,
       sum(h.arr_amt) arr_amt
  from HPNRET_FORM249_ARREARS_TAB H
 where h.year = '&year_i'
   and h.period = '&period_i'
   and H.Act_Out_Bal > 0
   and h.shop_code not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and h.shop_code not in ('SAPM', 'SCOM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   /*and h.acct_no != 'DBL-H2291'*/
 group by h.year, h.period

--***** End swh data

--***** Start CARR Data
--Arr_Mon range table less than 12 months
select --h.year,
       --h.period,
       to_char(h.arr_mon) "Range",
       sum(h.act_out_bal) Past_Due,
       sum(h.actual_ucc) UCC,
       count(h.acct_no) NoACC
  from HPNRET_FORM249_ARREARS_TAB H
 where h.year = '&year_i'
   and h.period = '&period_i'
   and h.act_out_bal > 0
   and h.arr_mon <= 12
   and h.shop_code not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and h.shop_code not in ('SAPM', 'SCOM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   /*and h.acct_no != 'DBL-H2291'*/
 group by h.year, h.period, h.arr_mon

union

--Arr_Mon range table greater than 12 months
select --h.year,
       --h.period,
       (min(h.arr_mon) - 1) || '+' "Range",
       sum(h.act_out_bal) Past_Due,
       sum(h.actual_ucc) UCC,
       count(h.acct_no) NoACC
  from HPNRET_FORM249_ARREARS_TAB H
 where h.year = '&year_i'
   and h.period = '&period_i'
   and h.act_out_bal > 0
   and h.arr_mon > 12
   and h.shop_code not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and h.shop_code not in ('SAPM', 'SCOM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   /*and h.acct_no != 'DBL-H2291'*/
 group by h.year, h.period
--***** End CARR Data
