--*****Wholesale Sales Data
select 
    --*
    t.invoice_id,
    t.c10 SITE,
    t.c1 ORDER_NO,
    to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
    /*to_char((select c.date_entered  from ifsapp.CUSTOMER_ORDER_LINE_TAB c where c.order_no = t.c1 and c.line_no = t.c2 and c.rel_no = t.c3 
      \*group by c.order_no, c.line_no, c.rel_no*\), 'YYYY/MM/DD') DATE_ENTERED,
    to_char((select c.planned_delivery_date from ifsapp.CUSTOMER_ORDER_LINE_TAB c where c.order_no = t.c1 and c.line_no = t.c2 and c.rel_no = t.c3 
      \*group by c.order_no, c.line_no, c.rel_no*\), 'YYYY/MM/DD') PLANNED_DELIVERY_DATE,
    to_char((select c.real_ship_date from ifsapp.CUSTOMER_ORDER_LINE_TAB c where c.order_no = t.c1 and c.line_no = t.c2 and c.rel_no = t.c3 
      \*group by c.order_no, c.line_no, c.rel_no*\), 'YYYY/MM/DD') REAL_SHIP_DATE,*/
    t.identity CUSTOMER_NO,
    ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
    --t.item_data,
    --t.creator,
    --ifsapp.cust_ord_customer_api.get_cust_grp(t.identity) CUSTOMER_GROUP,
    (select max(c.vendor_no) from ifsapp.CUSTOMER_ORDER_LINE_TAB c where c.order_no = t.c1 and c.line_no = t.c2 and c.rel_no = t.c3 
      group by c.order_no, c.line_no, c.rel_no) DELIVERY_SITE,
    t.c5 PRODUCT_CODE,
    --IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
    case when t.net_curr_amount != 0 then (t.n2 * (t.net_curr_amount/abs(t.net_curr_amount))) 
      else t.n2 
        end SALES_QUANTITY,
    t.net_curr_amount SALES_PRICE,
    round(t.n5, 2) "DISCOUNT(%)",
    t.vat_curr_amount VAT,    
    case when t.net_curr_amount != 0 
      then (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
              * (t.net_curr_amount/abs(t.net_curr_amount)) 
      else (select l.base_sale_unit_price from CUSTOMER_ORDER_LINE l where 
              l.order_no = t.c1 and l.line_no = t.c2 and l.rel_no = t.c3 and l.catalog_no = t.c5)
      end unit_nsp,
    t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)"
    --t.c2 LINE_NO,
    --t.c3 REL_NO,    
    --t.c6,    
    --t.c13 CUSTOMER_NO,    
    --t.n4,
from 
  ifsapp.invoice_item_tab t,
  ifsapp.INVOICE_TAB i
where 
  t.invoice_id = i.invoice_id and
  --ifsapp.cust_ord_customer_api.get_cust_grp(t.identity) = '003' and
  --t.net_curr_amount > 0 and
  t.creator = 'CUSTOMER_ORDER_INV_ITEM_API' and /*in ('INVOICE_API', 'MAN_SUPP_INVOICE_API') and*/   
  t.rowstate = 'Posted' and
  i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and to_date('&to_date', 'yyyy/mm/dd') and
  IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV') and --, 'PKG', 'NON'
  --t.c10 = 'SHOM' --and
  t.c10 in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO') --and --'SESM', 'SAPM', 'SHOM'
  --t.c5 in ('SRREF-DF2-18', 'SRREF-G-BCD-192')
  --t.identity = 'W0000929-2' and
  --t.c1 = 'WSM-R10891' --and
  --t.c1 is not null and
  --t.n2 is not null and
  --i.party_type = 'CUSTOMER'
order by i.invoice_date, t.c10, t.c1


--Information Test in Invoice_Tab
/*select 
    --*
    i.identity,
    i.invoice_id,
    i.rowstate,
    i.series_id,
    i.invoice_no,
    i.invoice_date,
    i.pay_term_id,
    i.delivery_identity,
    i.creators_reference,
    i.voucher_no_ref,
    i.net_curr_amount,
    i.vat_curr_amount,
    i.net_dom_amount,
    i.vat_dom_amount,
    i.c7,
    i.create_state,
    i.payer_identity
from INVOICE_TAB i
where i.invoice_id = '2499187'*/
