select t.c10 "SITE",
       t.c1 ORDER_NO,
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.identity CUSTOMER_NO,
       ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
       (select c.vendor_no
          from ifsapp.CUSTOMER_ORDER_LINE_TAB c
         where c.order_no = t.c1
           and c.line_no = t.c2
           and c.rel_no = t.c3
           and c.line_item_no = t.n1) DELIVERY_SITE,
       t.c5 PRODUCT_CODE,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family(t.c10,
                                                                                                                t.c5)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(t.c10,
                                                                                                                    t.c5))) product_family,
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
       t.n5 "DISCOUNT(%)",
       t.net_curr_amount SALES_PRICE,
       t.vat_code,
       t.vat_curr_amount VAT,
       t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)"
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.net_curr_amount != 0
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG'/*, 'NON'*/)
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP',
                     'DSCP',
                     'FSCP', --New Service Center
                     'JSCP',
                     'KSCP',
                     'MSCP',
                     'NSCP',
                     'RPSP',
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC') --Service Sites
   /*and ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) in
       ('CashSale',
        'ReturnCompleted',
        'HireSale',
        'Returned',
        'ReturnAfterCashConv')*/
   /*and t.c10 like '&site'
   and t.c1 like '&order_no'
   and t.c5 like '&product_code'*/
 order by t.c10, t.c1
