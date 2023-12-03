--*****INV Sales with Cost Details
select s.*,
       (select h.area_code
          from ifsapp.shop_dts_info h
         where h.shop_code = s.site) area_code,
       (select h.district_code
          from ifsapp.shop_dts_info h
         where h.shop_code = s.site) district_code,
       p.product_family,
       p.brand,
       round((select c.cost
               from ifsapp.INVENT_ONLINE_COST_TAB c
              where c.year = extract(year from s.sales_date)
                and c.period = extract(month from s.sales_date)
                and c.contract = s.site
                and c.part_no = s.product_code),
             2) unit_cost,
       round(s.sales_quantity *
             (select c.cost
                from ifsapp.INVENT_ONLINE_COST_TAB c
               where c.year = extract(year from s.sales_date)
                 and c.period = extract(month from s.sales_date)
                 and c.contract = s.site
                 and c.part_no = s.product_code),
             2) total_cost
  from ifsapp.SBL_JR_SALES_DTL_INV s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.PRODUCT_CODE = p.product_code
 where s.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')

union all

--*****COMP Sales with Cost Details
select g.*,
       (select h.area_code
          from ifsapp.shop_dts_info h
         where h.shop_code = g.site) area_code,
       (select h.district_code
          from ifsapp.shop_dts_info h
         where h.shop_code = g.site) district_code,
       p.product_family,
       p.brand,
       round((select c.cost
               from ifsapp.INVENT_ONLINE_COST_TAB c
              where c.year = extract(year from g.sales_date)
                and c.period = extract(month from g.sales_date)
                and c.contract = g.site
                and c.part_no = g.product_code),
             2) unit_cost,
       round(g.sales_quantity *
             (select c.cost
                from ifsapp.INVENT_ONLINE_COST_TAB c
               where c.year = extract(year from g.sales_date)
                 and c.period = extract(month from g.sales_date)
                 and c.contract = g.site
                 and c.part_no = g.product_code),
             2) total_cost
  from ifsapp.SBL_JR_SALES_DTL_PKG_COMP g
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on g.PRODUCT_CODE = p.product_code
 where g.sales_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 order by 1, 2
