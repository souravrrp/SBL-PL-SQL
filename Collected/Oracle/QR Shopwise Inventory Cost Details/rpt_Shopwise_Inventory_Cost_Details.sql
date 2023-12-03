select t.stat_year,
       t.stat_period_no,
       t.contract,
       t.part_no,
       t.bf_balance,
       (select i.cost
          from INVENTORY_BALANCE i
         where i.year = t.stat_year
           and i.period = t.stat_period_no
           and i.site = t.contract
           and i.part_no = t.part_no
           and i.location = 'NORMAL') "COST",
       t.bf_balance * (select i.cost
                         from INVENTORY_BALANCE i
                        where i.year = t.stat_year
                          and i.period = t.stat_period_no
                          and i.site = t.contract
                          and i.part_no = t.part_no
                          and i.location = 'NORMAL') TOTAL_COST
  from ifsapp.REP246_TAB t
 where t.stat_year = '&year_i'
   and t.stat_period_no = '&period'
   and t.contract like '&shop_code'
