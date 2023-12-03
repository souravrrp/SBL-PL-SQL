--Product Group wise Opening Balance (246)       
select /*v.stat_year,
       v.stat_period_no,*/
       v.Product_Group,
       v.Product_Group_Desc,
       sum(v.cf_balance) open_balance
  from (select t.stat_year,
               t.stat_period_no,
               (select (select c.short_name
                          from product_info c
                         where c.group_no = p.group_no)
                  from product_category_info p
                 where p.product_code = t.part_no) Product_Group,
               (select (select c.product_group
                          from product_info c
                         where c.group_no = p.group_no)
                  from product_category_info p
                 where p.product_code = t.part_no) Product_Group_Desc,
               t.part_no,
               t.cf_balance
          from ifsapp.REP246_TAB t
         where t.stat_year = '&year_i'
           and t.stat_period_no = '&period') v
           where v.Product_Group in ('WM', 'MV', 'RC', 'EK', 'SP', 'IRON', 'GB', 'WF')
 group by v.stat_year, v.stat_period_no, v.Product_Group, v.Product_Group_Desc
 order by v.Product_Group
