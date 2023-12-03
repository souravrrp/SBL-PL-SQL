--***** Product-wise Sales Summary
select extract(year from s.sales_date) "YEAR",
       /*extract (month from s.sales_date) PERIOD,*/
       p.product_family,
       p.brand,
       s.product_code product,
       sum(s.sales_quantity) total_quantity,
       sum(s.sales_price) total_value
  from (select *
          from IFSAPP.SBL_JR_SALES_DTL_INV i
        union all
        select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.product_code = p.product_code
 where s.sales_price != 0
   and s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and s.status not in ('CashConverted', 'PositiveCashConv')
 group by extract(year from s.sales_date),
          p.product_family,
          p.brand,
          s.product_code
 order by 2, 3, 4
