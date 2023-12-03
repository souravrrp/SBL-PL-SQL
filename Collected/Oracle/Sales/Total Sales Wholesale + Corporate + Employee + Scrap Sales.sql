--*****Wholesale + Corporate + Employee + Scrap Sales Data
  select t.invoice_id,
         t.c10 SITE,
         t.c1 ORDER_NO,
         to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
         t.identity CUSTOMER_NO,
         ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
         (select max(c.vendor_no) from ifsapp.CUSTOMER_ORDER_LINE_TAB c where c.order_no = t.c1 and c.line_no = t.c2 and c.rel_no = t.c3 
          group by c.order_no, c.line_no, c.rel_no) DELIVERY_SITE,
         t.c5 PRODUCT_CODE,
         IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
         case when t.net_curr_amount != 0 then (t.n2 * (t.net_curr_amount/abs(t.net_curr_amount))) 
          else t.n2 
            end SALES_QUANTITY,
         case when t.net_curr_amount != 0 
         then (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
                l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
                * (t.net_curr_amount/abs(t.net_curr_amount)) 
         else (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
                l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
         end unit_nsp,
         t.net_curr_amount SALES_PRICE,
         round(t.n5, 2) "DISCOUNT(%)",
         t.vat_curr_amount VAT,
         t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)"
  from   ifsapp.invoice_item_tab t,
         ifsapp.INVOICE_TAB i
  where  t.invoice_id = i.invoice_id 
  --and    t.net_curr_amount != 0 
  and    t.creator = 'CUSTOMER_ORDER_INV_ITEM_API' 
  and    t.rowstate = 'Posted' 
  and    i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and to_date('&to_date', 'yyyy/mm/dd') 
  and    IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG') --, 'NON'
  and    t.c10 not in ('BSCP', 'BLSP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC') --Service Sites
  and    t.c10 not in ('JWSS', 'SAOS',  'SWSS', 'WSMO') --Wholesale Sites
  and    t.c10 not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM') --Corporate, Employee, & Scrap Sites
order by t.c10, t.c1, i.invoice_date
