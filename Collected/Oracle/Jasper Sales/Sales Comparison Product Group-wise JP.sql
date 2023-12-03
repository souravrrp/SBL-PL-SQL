select r.product_group,
       (select g2.serial_no
          from IFSAPP.SBL_JR_RST_PRODUCT_GROUP g2
         where g2.year = extract(year from $P{FROM_DATE})
           and g2.product_group = r.product_group) serial_no,
       sum(decode(extract(year from r.SALES_DATE),
                  extract(year from $P{FROM_DATE}),
                  r.SALES_QUANTITY,
                  0)) qtn_curr_year,
       sum(decode(extract(year from r.SALES_DATE),
                  extract(year from $P{FROM_DATE}),
                  r.SALES_PRICE,
                  0)) amount_curr_year,
       sum(decode(extract(year from r.SALES_DATE),
                  extract(year from add_months($P{FROM_DATE}, -12)),
                  r.SALES_QUANTITY,
                  0)) qtn_prev_year,
       sum(decode(extract(year from r.SALES_DATE),
                  extract(year from add_months($P{FROM_DATE}, -12)),
                  r.SALES_PRICE,
                  0)) amount_prev_year
  from (select s.*,
               (select g.product_group
                  from IFSAPP.SBL_JR_RST_PRODUCT_GROUP g
                 where g.year = extract(year from s.SALES_DATE)
                   and g.product_group_code =
                       (select m.product_group_code
                          from IFSAPP.SBL_JR_RST_PG_PF_MAP m
                         where m.year = extract(year from s.SALES_DATE)
                           and m.product_family_code = p.product_family_code)) product_group
          from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
         inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
            on s.PRODUCT_CODE = p.product_code
         where s.SALES_PRICE != 0
           and (s.sales_date between $P{FROM_DATE} and $P{TO_DATE} or
               s.sales_date between add_months($P{FROM_DATE}, -12) and
               add_months($P{TO_DATE}, -12))
           and (select m.product_group_code
                  from IFSAPP.SBL_JR_RST_PG_PF_MAP m
                 where m.year = extract(year from s.SALES_DATE)
                   and m.product_family_code = p.product_family_code) is not null) r
 group by r.product_group
 order by 2
