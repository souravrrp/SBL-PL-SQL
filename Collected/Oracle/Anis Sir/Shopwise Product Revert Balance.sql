--Shopwise Revert Balance
select --t.stat_year,
       t.stat_period_no,
       (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.Contract) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.Contract) district_code,
       t.contract,
       t.part_no,
       t.revert_bal revert_balance
  from ifsapp.REP246_TAB t
 where t.stat_year = '&year_i'
   and t.stat_period_no = '&period'
   and t.revert_bal > 0
 order by 3, 4
