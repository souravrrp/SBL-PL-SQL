--Cost of a component for a specific site & period
select *
  from IFSAPP.INVENT_ONLINE_COST_TAB c
 where c.year = 2016
   and c.period = 4
   and c.contract = 'ABDD'
   and c.part_no = 'SHCOM-KEYBOARD'
   
--Cost of the components of a package for a site with qty
select p.parent_part,
       p.catalog_no,
       p.contract,
       p.line_item_no,
       p.qty_per_assembly,
       (p.qty_per_assembly *
       (select c.cost
           from IFSAPP.INVENT_ONLINE_COST_TAB c
          where c.year =
                extract(year from to_date('&calc_date', 'YYYY/MM/DD'))
            and c.period =
                extract(month from to_date('&calc_date', 'YYYY/MM/DD'))
            and c.contract = p.contract
            and c.part_no = p.catalog_no)) comp_cost
  from IFSAPP.SALES_PART_PACKAGE_TAB p
 where p.catalog_no = 'SHCOM-SINGTECH-CORE'
   and p.contract = 'ABDD'


--Total cost of a package for a site
select /*p.parent_part,*/
       sum(p.qty_per_assembly *
           (select c.cost
              from IFSAPP.INVENT_ONLINE_COST_TAB c
             where c.year =
                   extract(year from to_date('&calc_date', 'YYYY/MM/DD'))
               and c.period =
                   extract(month from to_date('&calc_date', 'YYYY/MM/DD'))
               and c.contract = p.contract
               and c.part_no = p.catalog_no)) total_cost
  from IFSAPP.SALES_PART_PACKAGE_TAB p
 where p.parent_part = 'PKSHCOM-SINGTECH-COR-18.5'
   and p.contract = 'ABDD'
 group by p.parent_part

