create or replace view sbl_vw_wholesale_sales as
  select t.invoice_id,
         t.item_id,
         t.c10 "SITE",
         t.c1 ORDER_NO,
         t.c2 LINE_NO,
         t.c3 REL_NO,
         t.n1 LINE_ITEM_NO,
         t.c4 ACCT_LINE_NO,
         t.n9 RMA_NO,
         t.n10 RMA_LINE_NO,
         i.invoice_date SALES_DATE,
         t.identity CUSTOMER_NO,
         ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
         ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(t.identity) phone_no,
         IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(t.identity, 1) || ' ' ||
         IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(t.identity, 1) dealer_address,
         ifsapp.cust_ord_customer_api.get_cust_grp(t.identity) CUSTOMER_GROUP,
         (select c.vendor_no
            from ifsapp.CUSTOMER_ORDER_LINE_TAB c
           where c.order_no = t.c1
             and c.line_no = t.c2
             and c.rel_no = t.c3
             and c.line_item_no = t.n1) DELIVERY_SITE,
         t.c5 PRODUCT_CODE,
         t.c6 PRODUCT_DESC,
         IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) CATALOG_TYPE,
         case
           when t.net_curr_amount != 0 then
            t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
           else
            IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
         end SALES_QUANTITY,
         case
           when t.net_curr_amount < 0 and t.n1 = 0 then
             (select l.base_sale_unit_price
               from CUSTOMER_ORDER_LINE l
              where l.order_no = t.c1
                and l.line_no = t.c2
                and l.rel_no = t.c3
                and l.line_item_no = t.n1) *
            (t.net_curr_amount / abs(t.net_curr_amount))
           when t.net_curr_amount < 0 and t.n1 > 0 then
             (select l.part_price
               from CUSTOMER_ORDER_LINE l
              where l.order_no = t.c1
                and l.line_no = t.c2
                and l.rel_no = t.c3
                and l.line_item_no = t.n1) *
            (t.net_curr_amount / abs(t.net_curr_amount))
           else
            (select l.base_sale_unit_price
               from CUSTOMER_ORDER_LINE l
              where l.order_no = t.c1
                and l.line_no = t.c2
                and l.rel_no = t.c3
                and l.line_item_no = t.n1)
         end UNIT_NSP,
         round(t.n5, 2) DISCOUNT,
         t.net_curr_amount SALES_PRICE,
         t.vat_code,
         IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate('SBL', t.vat_code) vat_rate,
         t.vat_curr_amount VAT,
         t.net_curr_amount + t.vat_curr_amount RSP,
         i.pay_term_id,
         i.series_id,
         i.invoice_no,
         i.voucher_type_ref,
         i.voucher_no_ref,
         i.voucher_date_ref/*,
         (select n.delnote_no
          from IFSAPP.CUSTOMER_ORDER_DELIVERY_TAB n
         inner join IFSAPP.CUSTOMER_ORDER_LINE_TAB l
            on n.order_no = l.order_no
           and n.line_no = l.line_no
           and n.rel_no = l.rel_no
           and n.line_item_no = l.line_item_no
         inner join IFSAPP.CUSTOMER_ORDER_PUR_ORDER p
            on l.demand_order_ref1 = p.po_order_no
           and l.demand_order_ref2 = p.po_line_no
           and l.demand_order_ref3 = p.po_rel_no
         where p.oe_order_no = t.c1
           and p.oe_line_no = t.c2
           and p.oe_rel_no = t.c3
           and p.oe_line_item_no = t.n1) delnote_no*/
    from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
   where t.invoice_id = i.invoice_id
     and ifsapp.cust_ord_customer_api.get_cust_grp(t.identity) = '003'
     and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
     and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV'
     and t.rowstate = 'Posted';

