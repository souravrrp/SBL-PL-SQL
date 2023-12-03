--*****Sales Comparison Shopwise
select s.AREA_CODE,
       s.DISTRICT_CODE,
       s.SHOP_CODE,
       sum(decode(extract(year from s.SALES_DATE),
                  extract(year from to_date('&FROM_DATE', 'YYYY/MM/DD')),
                  s.SALES_QUANTITY,
                  0)) qtn_curr_year,
       sum(decode(extract(year from s.SALES_DATE),
                  extract(year from to_date('&FROM_DATE', 'YYYY/MM/DD')),
                  s.SALES_PRICE,
                  0)) amount_curr_year,
       sum(decode(extract(year from s.SALES_DATE),
                  extract(year from
                          add_months(to_date('&FROM_DATE', 'YYYY/MM/DD'),
                                     -12)),
                  s.SALES_QUANTITY,
                  0)) qtn_prev_year,
       sum(decode(extract(year from s.SALES_DATE),
                  extract(year from
                          add_months(to_date('&FROM_DATE', 'YYYY/MM/DD'),
                                     -12)),
                  s.SALES_PRICE,
                  0)) amount_prev_year
  from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.PRODUCT_CODE = p.product_code
 where s.SALES_PRICE != 0
   and (s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD') or
       s.sales_date between
       add_months(to_date('&FROM_DATE', 'YYYY/MM/DD'), -12) and
       add_months(to_date('&TO_DATE', 'YYYY/MM/DD'), -12))
 group by s.AREA_CODE, s.DISTRICT_CODE, s.SHOP_CODE
 order by 2
