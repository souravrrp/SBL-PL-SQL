create or replace view SBL_LATEST_PRICE_LIST as
select t.price_list_no PRICE_LIST_NO,
       t.CATALOG_NO SALE_PART_NO,
       IFSAPP.SALES_PART_API.Get_Catalog_Desc('SCOM', t.catalog_no) PART_DESC,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.CATALOG_NO)) BRAND,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.CATALOG_NO),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                t.CATALOG_NO)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                    t.CATALOG_NO))) PRODUCT_FAMILY,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.CATALOG_NO),
              'PKG',
              IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                             t.CATALOG_NO)),
              IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                        t.CATALOG_NO))) COMMODITY_GROUP2,
       TO_CHAR(t.VALID_FROM_DATE, 'YYYY/MM/DD') VALID_FROM_DATE,
       t.SALES_PRICE SALE_PRICE_NSP,
       f.FEE_CODE TAX_CODE,
       f.FEE_RATE TAX_RATE,
       CASE
         WHEN T.PRICE_LIST_NO = '4' THEN
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 2
                 and d.channel in ('ALL', '736')
                 and d.part_no = t.catalog_no),
              0)
         WHEN T.PRICE_LIST_NO = '7' THEN
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 2
                 and d.channel in ('ALL', '2048')
                 and d.part_no = t.catalog_no),
              0)
         ELSE
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 2
                 and d.channel in ('ALL', '24')
                 and d.part_no = t.catalog_no),
              0)
       END CO_DISCOUNT,
       CASE
         WHEN T.PRICE_LIST_NO = '4' THEN
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 1
                 and d.channel in ('ALL', '736')
                 and d.part_no = t.catalog_no),
              0)
         WHEN T.PRICE_LIST_NO = '7' THEN
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 1
                 and d.channel in ('ALL', '2048')
                 and d.part_no = t.catalog_no),
              0)
         ELSE
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 1
                 and d.channel in ('ALL', '24')
                 and d.part_no = t.catalog_no),
              0)
       END HP_DISCOUNT,
       CASE
         WHEN T.PRICE_LIST_NO = '4' THEN
          t.SALES_PRICE + round(t.SALES_PRICE * (f.FEE_RATE / 100), 2) -
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 2
                 and d.channel in ('ALL', '736')
                 and d.part_no = t.catalog_no),
              0)
         WHEN T.PRICE_LIST_NO = '7' THEN
          t.SALES_PRICE + round(t.SALES_PRICE * (f.FEE_RATE / 100), 2) -
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 2
                 and d.channel in ('ALL', '2048')
                 and d.part_no = t.catalog_no),
              0)
         ELSE
          t.SALES_PRICE + round(t.SALES_PRICE * (f.FEE_RATE / 100), 2) -
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 2
                 and d.channel in ('ALL', '24')
                 and d.part_no = t.catalog_no),
              0)
       END CASH_PRICE,
       CASE
         WHEN T.PRICE_LIST_NO = '4' THEN
          t.SALES_PRICE + round(t.SALES_PRICE * (f.FEE_RATE / 100), 2) -
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 1
                 and d.channel in ('ALL', '736')
                 and d.part_no = t.catalog_no),
              0)
         WHEN T.PRICE_LIST_NO = '7' THEN
          t.SALES_PRICE + round(t.SALES_PRICE * (f.FEE_RATE / 100), 2) -
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 1
                 and d.channel in ('ALL', '2048')
                 and d.part_no = t.catalog_no),
              0)
         ELSE
          t.SALES_PRICE + round(t.SALES_PRICE * (f.FEE_RATE / 100), 2) -
          nvl((select d.amount
                from ifsapp.SBL_DISCOUNT_PROMOTION d
               where trunc(sysdate) between d.valid_from and d.valid_to
                 and d.transaction_no = 1
                 and d.channel in ('ALL', '24')
                 and d.part_no = t.catalog_no),
              0)
       END HIRE_CASH_PRICE,
       CASE
         WHEN T.PRICE_LIST_NO = '1' THEN
          nvl((select ct.amount
                from ifsapp.commission_agree_line_tab ct
               inner join (select ch.agreement_id,
                                 ch.commission_sales_type,
                                 ch.catalog_no,
                                 min(abs(ch.VALID_FROM - trunc(sysdate))) diff
                            from ifsapp.commission_agree_line_tab ch
                           where ch.AGREEMENT_ID = 'SP_SC_RTL'
                             and ch.COMMISSION_SALES_TYPE = 'CASH'
                             and ch.location_no = 'NORMAL'
                           group by ch.agreement_id,
                                    ch.commission_sales_type,
                                    ch.catalog_no) ca
                  on ct.agreement_id = ca.agreement_id
                 and ct.commission_sales_type = ca.commission_sales_type
                 and ct.catalog_no = ca.catalog_no
               where abs(ct.VALID_FROM - trunc(sysdate)) = ca.diff
                 and ct.catalog_no = t.catalog_no
                 and ct.location_no = 'NORMAL'
              /*and rownum <= 1*/
              ),
              0)
         else
          0
       end CASH_COMMISSION,
       CASE
         WHEN T.PRICE_LIST_NO = '1' THEN
          nvl((select ct.amount
                from ifsapp.commission_agree_line_tab ct
               inner join (select ch.agreement_id,
                                 ch.commission_sales_type,
                                 ch.catalog_no,
                                 min(abs(ch.VALID_FROM - trunc(sysdate))) diff
                            from ifsapp.commission_agree_line_tab ch
                           where ch.AGREEMENT_ID = 'SP_SC_RTL'
                             and ch.COMMISSION_SALES_TYPE = 'HP'
                             and ch.location_no = 'NORMAL'
                           group by ch.agreement_id,
                                    ch.commission_sales_type,
                                    ch.catalog_no) ca
                  on ct.agreement_id = ca.agreement_id
                 and ct.commission_sales_type = ca.commission_sales_type
                 and ct.catalog_no = ca.catalog_no
               where abs(ct.VALID_FROM - trunc(sysdate)) = ca.diff
                 and ct.catalog_no = t.catalog_no
                 and ct.location_no = 'NORMAL'
              /*and rownum <= 1*/
              ),
              0)
         else
          0
       end HP_COMMISSION
  FROM ifsapp.SALES_PRICE_LIST_PART_TAB t
 inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                    lp.catalog_no,
                    min(abs(lp.valid_from_date - trunc(sysdate))) diff
               from IFSAPP.SALES_PRICE_LIST_PART lp
              where lp.valid_from_date <= trunc(sysdate)
              group by lp.price_list_no, lp.catalog_no) m
    on t.price_list_no = m.price_list_no
   and t.catalog_no = m.catalog_no
 inner join IFSAPP.statutory_fee_tab f
    on t.CASH_TAX_CODE = f.FEE_CODE
 where abs(t.valid_from_date - trunc(sysdate)) = m.diff
 order by 1, 2
