-- Inventory Balance Summary
select *
  from (select t.year,
               t.period,
               t.site,
               t.part_no,
               t.site || '-' || t.part_no site_part_no,
               sum(t.closing_bal) closing_bal,
               sum(t.closing_bal * t.cost) total_cost,
               sum(t.in_transit) in_transit,
               sum(t.in_transit * t.in_transit) in_transit_cost
          from IFSAPP.INVENTORY_BALANCE t
         where t.year = '&year_i'
           and t.period = '&period'
         group by t.year, t.period, t.site, t.part_no) v
 where (v.closing_bal > 0 or v.in_transit > 0)
 order by v.site, v.part_no
