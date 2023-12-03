--Product Comparison
--Product Groups of Models using subquery
select r.*,
       (select g.product_group
          from IFSAPP.SBL_JR_RST_PRODUCT_GROUP g
         where g.year = 2018
           and g.product_group_code = r.product_group_code) product_group
  from (select p.*,
               (select m.product_group_code
                  from IFSAPP.SBL_JR_RST_PG_PF_MAP m
                 where m.year = 2018
                   and m.product_family_code = p.product_family_code) product_group_code
          from IFSAPP.SBL_JR_PRODUCT_DTL_INFO p) r
 where r.product_group_code is not null/*;*/

minus

--Product Groups of Models using join
select p.*, m.product_group_code, g.product_group
  from IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
 inner join IFSAPP.SBL_JR_RST_PG_PF_MAP m
    on p.product_family_code = m.product_family_code
 inner join IFSAPP.SBL_JR_RST_PRODUCT_GROUP g
    on m.product_group_code = g.product_group_code
 where m.year = 2018
   and g.year = 2018;

--Model in the Product Table
select s.PRODUCT_CODE
  from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
 where s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
 group by s.PRODUCT_CODE
minus
select p.product_code from IFSAPP.SBL_JR_PRODUCT_DTL_INFO p;

--Sales No of rows using subquery
select count(*) s.*
  from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.PRODUCT_CODE = p.product_code
 where s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and (select m.product_group_code
          from IFSAPP.SBL_JR_RST_PG_PF_MAP m
         where m.year = extract(year from s.SALES_DATE)
           and m.product_family_code = p.product_family_code) is not null/*;*/

/*minus*/

--Sales No of rows using join
select count(*) /*s.**/
  from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.PRODUCT_CODE = p.product_code
 inner join IFSAPP.SBL_JR_RST_PG_PF_MAP m
    on p.product_family_code = m.product_family_code
 inner join IFSAPP.SBL_JR_RST_PRODUCT_GROUP g
    on m.product_group_code = g.product_group_code
 where s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and m.year = extract(year from to_date('&FROM_DATE', 'YYYY/MM/DD'))
   and g.year = extract(year from to_date('&FROM_DATE', 'YYYY/MM/DD'))/*;*/
