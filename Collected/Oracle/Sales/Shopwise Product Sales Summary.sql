select --v.SITE,
       v.year,
       v.period,
       v.brand,
       v.product_family,
       v.commodity_group2,
       v.PRODUCT_CODE,
       sum(v.SALES_QUANTITY) SALES_QUANTITY,
       sum(v.SALES_PRICE) total_sales_price,
       sum(v.VAT) total_VAT,
       sum(v.RSP) total_RSP
from 
      (select t.c10 "SITE",
             t.c1 ORDER_NO,
             ifsapp.get_sbl_account_status(t.c1, t.c2, t.c3, t.c5, t.net_curr_amount, i.invoice_date) status,
             extract (year from i.invoice_date) year,
             extract (month from i.invoice_date) period,
             to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
             t.c5 PRODUCT_CODE,
             IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', t.c5)) brand,
             ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM', t.c5)) product_family,
             IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM', t.c5)) commodity_group2,
             case when t.net_curr_amount != 0 then 
                 t.n2 * (t.net_curr_amount/abs(t.net_curr_amount))
               else t.n2
               end SALES_QUANTITY,
             t.net_curr_amount SALES_PRICE,
             case when t.net_curr_amount != 0 then 
                 (select l.base_sale_unit_price 
                  from   CUSTOMER_ORDER_LINE l 
                  where  l.order_no = t.c1 
                   and   l.line_no = t.c2 
                   and   l.rel_no = t.c3 
                   and   l.catalog_no = t.c5) * (t.net_curr_amount/abs(t.net_curr_amount)) 
               else (select l.base_sale_unit_price 
                     from   CUSTOMER_ORDER_LINE l 
                     where  l.order_no = t.c1 
                     and    l.line_no = t.c2 
                     and    l.rel_no = t.c3 
                     and    l.catalog_no = t.c5)
               end UNIT_NSP,
             t.n5 "DISCOUNT(%)",
             t.vat_curr_amount VAT,    
             (t.net_curr_amount + t.vat_curr_amount) "RSP"
      from   ifsapp.invoice_item_tab t,
             ifsapp.INVOICE_TAB i
      where  t.invoice_id = i.invoice_id 
        and  t.creator = 'CUSTOMER_ORDER_INV_ITEM_API' 
        and  t.rowstate = 'Posted' 
        and  IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG', 'NON') 
        and  t.c10 not in ('BSCP', 'BLSP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC') 
        and  i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and to_date('&to_date', 'yyyy/mm/dd') 
        and  t.net_curr_amount != 0
    order by t.c10, t.c1, i.invoice_date) v

where    v.PRODUCT_CODE like '%FUR-%' --BOREF-%, BOWM-%,
group by /*v.SITE,*/ v.year, v.period, v.brand, v.product_family, v.commodity_group2, v.PRODUCT_CODE
