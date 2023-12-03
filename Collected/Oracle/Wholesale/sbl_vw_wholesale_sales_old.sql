create or replace view sbl_vw_wholesale_sales as
select t.invoice_id,
       t.c10 SITE,
       t.c1 ORDER_NO,
       t.c2 LINE_NO,
       t.c3 REL_NO,
       t.n9 RMA_NO,
       i.invoice_date SALES_DATE,
       t.identity CUSTOMER_NO,
       ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(t.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(t.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(t.identity, 1) dealer_address,
       t.creator,
       ifsapp.cust_ord_customer_api.get_cust_grp(t.identity) CUSTOMER_GROUP,
       (select max(c.vendor_no)
          from ifsapp.CUSTOMER_ORDER_LINE_TAB c
         where c.order_no = t.c1
           and c.line_no = t.c2
           and c.rel_no = t.c3
         group by c.order_no, c.line_no, c.rel_no) DELIVERY_SITE,
       t.c5 PRODUCT_CODE,
       t.c6 PRODUCT_DESC,
       IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) CATALOG_TYPE,
       case
         when t.net_curr_amount != 0 then
          (t.net_curr_amount / abs(t.net_curr_amount)) * t.n2
         else
          t.n2
       end SALES_QUANTITY,
       t.net_curr_amount SALES_PRICE,
       round(t.n5, 2) DISCOUNT,
       t.vat_curr_amount VAT,
       case
         when t.net_curr_amount != 0 then
          (select l.base_sale_unit_price
             from CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.catalog_no = t.c5) *
          (t.net_curr_amount / abs(t.net_curr_amount))
         else
          (select l.base_sale_unit_price
             from CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.catalog_no = t.c5)
       end unit_nsp,
       t.net_curr_amount + t.vat_curr_amount RSP,
       i.series_id,
       i.invoice_no,
       i.pay_term_id
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and ifsapp.cust_ord_customer_api.get_cust_grp(t.identity) = '003'
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV'
   and t.rowstate = 'Posted';
