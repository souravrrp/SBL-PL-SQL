select extract(year from i.invoice_date) "YEAR",
       extract(month from i.invoice_date) PERIOD,
       sum(t.net_curr_amount) TOTAL_SALES_PRICE,
       sum(case
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
           end * t.n2) TOTAL_NSP,
       sum(t.vat_curr_amount) TOTAL_VAT
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
                     'CXSP', --New Service Center
                     'DSCP',
                     'JSCP',
                     'KSCP', --New Service Center
                     'MSCP',
                     'NSCP', --New Service Center
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
 group by extract(year from i.invoice_date),
          extract(month from i.invoice_date)
