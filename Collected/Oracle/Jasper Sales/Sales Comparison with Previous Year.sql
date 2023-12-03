--Sales Comparison with Previous Year
--Sales Details
select s.AREA_CODE,
       s.DISTRICT_CODE,
       s.SHOP_CODE,
       s.ORDER_NO,
       s.PRODUCT_CODE,
       p.product_family,
       (select g.product_group
          from IFSAPP.SBL_JR_RST_PRODUCT_GROUP g
         where g.year = extract(year from s.SALES_DATE)
           and g.product_group_code =
               (select m.product_group_code
                  from IFSAPP.SBL_JR_RST_PG_PF_MAP m
                 where m.year = extract(year from s.SALES_DATE)
                   and m.product_family_code = p.product_family_code)) product_group,
       s.SALES_DATE,
       extract(year from s.SALES_DATE) sales_year,
       s.SALES_QUANTITY,
       s.SALES_PRICE,
       s.Status
  from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.PRODUCT_CODE = p.product_code
 where s.SALES_PRICE != 0
   and s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and (select m.product_group_code
          from IFSAPP.SBL_JR_RST_PG_PF_MAP m
         where m.year = extract(year from s.SALES_DATE)
           and m.product_family_code = p.product_family_code) is not null

union all

--Sales Details Previous Year
select s.AREA_CODE,
       s.DISTRICT_CODE,
       s.SHOP_CODE,
       s.ORDER_NO,
       s.PRODUCT_CODE,
       p.product_family,
       (select g.product_group
          from IFSAPP.SBL_JR_RST_PRODUCT_GROUP g
         where g.year = extract(year from s.SALES_DATE)
           and g.product_group_code =
               (select m.product_group_code
                  from IFSAPP.SBL_JR_RST_PG_PF_MAP m
                 where m.year = extract(year from s.SALES_DATE)
                   and m.product_family_code = p.product_family_code)) product_group,
       s.SALES_DATE,
       extract(year from s.SALES_DATE) sales_year,
       s.SALES_QUANTITY,
       s.SALES_PRICE,
       s.Status
  from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.PRODUCT_CODE = p.product_code
 where s.SALES_PRICE != 0
   and s.sales_date between
       add_months(to_date('&FROM_DATE', 'YYYY/MM/DD'), -12) and
       add_months(to_date('&TO_DATE', 'YYYY/MM/DD'), -12)
   and (select m.product_group_code
          from IFSAPP.SBL_JR_RST_PG_PF_MAP m
         where m.year = extract(year from s.SALES_DATE)
           and m.product_family_code = p.product_family_code) is not null
 order by 8, 2, 3
