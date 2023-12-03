--*****Product Margin Report as per 246
create or replace view sbl_product_margin as
  select t.stat_year "YEAR",
         t.stat_period_no "PERIOD",
         t.part_no,
         IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Code('SCOM',
                                                                                                           t.part_no)) brand,
         IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM',
                                                                                                               t.part_no)) product_family,
         sum(t.cf_balance) total_month_end_stock,
         (select sum(s.qty_onhand)
            from ifsapp.INVENTORY_PART_IN_STOCK_NOPAL s
           where s.part_no = t.part_no) current_stock,
         (select p.valid_from_date
            from ifsapp.SALES_PRICE_LIST_PART p
           where p.catalog_no = t.part_no
             and p.price_list_no = '1'
             and p.valid_from_date <= sysdate
             and p.valid_from_date =
                 (select max(p1.valid_from_date)
                    from ifsapp.SALES_PRICE_LIST_PART p1
                   where p1.catalog_no = p.catalog_no
                     and p1.price_list_no = '1')) price_date,
         nvl((select p.sales_price
               from ifsapp.SALES_PRICE_LIST_PART p
              where p.catalog_no = t.part_no
                and p.price_list_no = '1'
                and p.valid_from_date <= sysdate
                and p.valid_from_date =
                    (select max(p1.valid_from_date)
                       from ifsapp.SALES_PRICE_LIST_PART p1
                      where p1.catalog_no = p.catalog_no
                        and p1.price_list_no = '1')),
             0) sale_price,
         nvl((select d.amount
               from ifsapp.SBL_DISCOUNT_PROMOTION d
              where d.valid_from <= sysdate
                and d.valid_to >= sysdate
                and d.part_no = t.part_no),
             0) discount,
         (nvl((select p.sales_price
                from ifsapp.SALES_PRICE_LIST_PART p
               where p.catalog_no = t.part_no
                 and p.price_list_no = '1'
                 and p.valid_from_date <= sysdate
                 and p.valid_from_date =
                     (select max(p1.valid_from_date)
                        from ifsapp.SALES_PRICE_LIST_PART p1
                       where p1.catalog_no = p.catalog_no
                         and p1.price_list_no = '1')),
              0) - nvl((select d.amount
                          from ifsapp.SBL_DISCOUNT_PROMOTION d
                         where d.valid_from <= sysdate
                           and d.valid_to >= sysdate
                           and d.part_no = t.part_no),
                        0)) discounted_sale_price,
         ifsapp.STATUTORY_FEE_API.Get_Fee_Rate('SBL',
                                               (select p.cash_tax_code
                                                  from ifsapp.SALES_PRICE_LIST_PART p
                                                 where p.price_list_no = '1'
                                                   and p.valid_from_date <=
                                                       sysdate
                                                   and p.valid_from_date =
                                                       (select max(p1.valid_from_date)
                                                          from ifsapp.SALES_PRICE_LIST_PART p1
                                                         where p1.price_list_no = '1'
                                                           and p1.catalog_no =
                                                               p.catalog_no)
                                                   and p.catalog_no = t.part_no)) VAT_RATE,
         round(((ifsapp.STATUTORY_FEE_API.Get_Fee_Rate('SBL',
                                                       (select p.cash_tax_code
                                                          from ifsapp.SALES_PRICE_LIST_PART p
                                                         where p.price_list_no = '1'
                                                           and p.valid_from_date <=
                                                               sysdate
                                                           and p.valid_from_date =
                                                               (select max(p1.valid_from_date)
                                                                  from ifsapp.SALES_PRICE_LIST_PART p1
                                                                 where p1.price_list_no = '1'
                                                                   and p1.catalog_no =
                                                                       p.catalog_no)
                                                           and p.catalog_no =
                                                               t.part_no))) / 100) *
               (select p.sales_price
                  from ifsapp.SALES_PRICE_LIST_PART p
                 where p.catalog_no = t.part_no
                   and p.price_list_no = '1'
                   and p.valid_from_date <= sysdate
                   and p.valid_from_date =
                       (select max(p1.valid_from_date)
                          from ifsapp.SALES_PRICE_LIST_PART p1
                         where p1.catalog_no = p.catalog_no
                           and p1.price_list_no = '1')),
               2) VAT,
         round((select c.cost
                 from ifsapp.COST_PER_PART_TAB c
                where c.year = t.stat_year
                  and c.period = t.stat_period_no
                  and c.part_no = t.part_no),
               2) "COST",
         round((nvl((select p.sales_price
                      from ifsapp.SALES_PRICE_LIST_PART p
                     where p.catalog_no = t.part_no
                       and p.price_list_no = '1'
                       and p.valid_from_date <= sysdate
                       and p.valid_from_date =
                           (select max(p1.valid_from_date)
                              from ifsapp.SALES_PRICE_LIST_PART p1
                             where p1.catalog_no = p.catalog_no
                               and p1.price_list_no = '1')),
                    0) - nvl((select d.amount
                                from ifsapp.SBL_DISCOUNT_PROMOTION d
                               where d.valid_from <= sysdate
                                 and d.valid_to >= sysdate
                                 and d.part_no = t.part_no),
                              0) -
               (select c.cost
                   from ifsapp.COST_PER_PART_TAB c
                  where c.year = t.stat_year
                    and c.period = t.stat_period_no
                    and c.part_no = t.part_no)),
               2) GM,
         case
           when (select p.sales_price
                   from ifsapp.SALES_PRICE_LIST_PART p
                  where p.catalog_no = t.part_no
                    and p.price_list_no = '1'
                    and p.valid_from_date <= sysdate
                    and p.valid_from_date =
                        (select max(p1.valid_from_date)
                           from ifsapp.SALES_PRICE_LIST_PART p1
                          where p1.catalog_no = p.catalog_no
                            and p1.price_list_no = '1')) != 0 then
            round((((nvl((select p.sales_price
                           from ifsapp.SALES_PRICE_LIST_PART p
                          where p.catalog_no = t.part_no
                            and p.price_list_no = '1'
                            and p.valid_from_date <= sysdate
                            and p.valid_from_date =
                                (select max(p1.valid_from_date)
                                   from ifsapp.SALES_PRICE_LIST_PART p1
                                  where p1.catalog_no = p.catalog_no
                                    and p1.price_list_no = '1')),
                         0) - nvl((select d.amount
                                       from ifsapp.SBL_DISCOUNT_PROMOTION d
                                      where d.valid_from <= sysdate
                                        and d.valid_to >= sysdate
                                        and d.part_no = t.part_no),
                                     0) -
                  (select c.cost
                        from ifsapp.COST_PER_PART_TAB c
                       where c.year = t.stat_year
                         and c.period = t.stat_period_no
                         and c.part_no = t.part_no)) /
                  (nvl((select p.sales_price
                           from ifsapp.SALES_PRICE_LIST_PART p
                          where p.catalog_no = t.part_no
                            and p.price_list_no = '1'
                            and p.valid_from_date <= sysdate
                            and p.valid_from_date =
                                (select max(p1.valid_from_date)
                                   from ifsapp.SALES_PRICE_LIST_PART p1
                                  where p1.catalog_no = p.catalog_no
                                    and p1.price_list_no = '1')),
                         0) - nvl((select d.amount
                                       from ifsapp.SBL_DISCOUNT_PROMOTION d
                                      where d.valid_from <= sysdate
                                        and d.valid_to >= sysdate
                                        and d.part_no = t.part_no),
                                     0))) * 100),
                  2)
           else
            0
         end "GMP"
    from ifsapp.REP246_TAB t
   where IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM', t.part_no) not in
         ('ACNML',
          'ADORM',
          'AVRML',
          'SRCRM',
          'RBOOK',
          'S-AC',
          'S-COM',
          'S-CTV',
          'S-DVD',
          'S-GEN',
          'S-IPS',
          'S-MC',
          'S-OTS',
          'S-OVN',
          'S-REF',
          'S-SWM',
          'S-WM',
          'TR')
   group by t.stat_year, t.stat_period_no, t.part_no
   order by t.part_no
