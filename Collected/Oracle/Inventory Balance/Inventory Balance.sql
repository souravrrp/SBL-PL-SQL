select t.year,
       t.period,
       t.site,
       t.location,
       --t.part_no,
       --t.closing_bal,
       --t.cost,
       round(sum(t.closing_bal * t.cost), 2) total_cost
  from INVENTORY_BALANCE_TAB t
 where t.year = 2015
   and t.period = 7
   and t.site = 'ABDD'
 group by t.year, t.period, t.site, t.location--, t.part_no
 --order by t.part_no
