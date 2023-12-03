--Site & Brandwise Sales Summary
select t.c10 "SITE",
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.c5)) brand,
       SUM(case
             when t.net_curr_amount != 0 then
              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
             else
              t.n2
           end) TOTAL_SALES_QUANTITY,
       SUM(t.net_curr_amount) TOTAL_SALES_PRICE
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG', 'NON')
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and t.net_curr_amount != 0
   AND t.c10 IN ('NGJB', 'DUTB', 'DGNB')
   AND ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.c5)) IN
       ('Color Television LCD/Plasma/RPT', 'Panel Television')
 GROUP BY T.C10,
          IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                            t.c5))
 order by t.c10,
          IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                            t.c5))
