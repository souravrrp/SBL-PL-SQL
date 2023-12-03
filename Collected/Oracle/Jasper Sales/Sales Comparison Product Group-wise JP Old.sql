select g.year,
       g.serial_no,
       g.product_group_code,
       g.product_group,
       (select sum(s.SALES_PRICE) SALES_PRICE
          from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
         inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
            on s.PRODUCT_CODE = p.product_code
         where s.SALES_PRICE != 0
           and s.sales_date between $P{FROM_DATE} and
               $P{TO_DATE} 
           and (select g2.product_group
                  from IFSAPP.SBL_JR_RST_PRODUCT_GROUP g2
                 where g2.year = extract(year from s.SALES_DATE)
                   and g2.product_group_code = 
                       (select m.product_group_code
                          from IFSAPP.SBL_JR_RST_PG_PF_MAP m
                         where m.year = extract(year from s.SALES_DATE)
                           and m.product_family_code = p.product_family_code)) =
               g.product_group) "2018",
       (select sum(s.SALES_PRICE) SALES_PRICE
          from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
         inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
            on s.PRODUCT_CODE = p.product_code
         where s.SALES_PRICE != 0
           and s.sales_date between
               add_months($P{FROM_DATE}, -12) and
               add_months($P{TO_DATE}, -12)
           and (select g2.product_group
                  from IFSAPP.SBL_JR_RST_PRODUCT_GROUP g2
                 where g2.year = extract(year from s.SALES_DATE)
                   and g2.product_group_code =
                       (select m.product_group_code
                          from IFSAPP.SBL_JR_RST_PG_PF_MAP m
                         where m.year = extract(year from s.SALES_DATE)
                           and m.product_family_code = p.product_family_code)) =
               g.product_group) "2017"
  from IFSAPP.SBL_JR_RST_PRODUCT_GROUP g
 where g.year = extract(year from $P{FROM_DATE})
 order by g.serial_no
