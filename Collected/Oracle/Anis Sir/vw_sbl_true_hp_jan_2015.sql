create or replace view sbl_true_hp_jan_2015 as
  select h.year,
         h.period,
         h.acct_no ,
         trunc(h.cash_conversion_on_date) cash_conversion_on_date
  from   HPNRET_FORM249_ARREARS_TAB h
  where  h.year = 2015 
  and    h.period = 1 
  and    trunc(h.cash_conversion_on_date) between to_date('2014/12/1', 'YYYY/MM/DD') and to_date('2014/12/31', 'YYYY/MM/DD')
