create or replace view sbl_auth_var_cc as
select t.account_no
  from IFSAPP.HPNRET_AUTH_VARIATION t
  where t.utilized = 1
  and t.variation_db = 6
  and t.from_date >= to_date('2014/1/1','YYYY/MM/DD') 
  and t.to_date <= to_date('2015/5/31','YYYY/MM/DD')
