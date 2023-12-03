--Wholesale Order Line Discount
select ifsapp.customer_order_line_api.Get_Contract(d.order_no,
                                                   d.line_no,
                                                   d.rel_no,
                                                   d.line_item_no) Contract,
       d.order_no,
       d.line_no,
       d.rel_no,
       d.line_item_no,
       ifsapp.customer_order_line_api.Get_Catalog_No(d.order_no,
                                                     d.line_no,
                                                     d.rel_no,
                                                     d.line_item_no) Catalog_No,
       d.discount_type,
       d.discount_no,
       --d.discount_line_no,
       d.discount_amount,
       d.calculation_basis,
       d.price_currency    Sale_Price,
       --d.price_base,
       d.remarks,
       trunc(d.rowversion) rowversion
  from IFSAPP.CUST_ORDER_LINE_DISCOUNT_TAB d
 where trunc(d.rowversion) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   AND D.ORDER_NO not in (select ORDER_NO
                            from HPNRET_CUSTOMER_ORDER_TAB r
                           where r.ORDER_NO = D.ORDER_NO
                             and r.CASH_CONV = 'TRUE')
   and ifsapp.customer_order_line_api.Get_Contract(d.order_no,
                                                   d.line_no,
                                                   d.rel_no,
                                                   d.line_item_no) in
       ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
 order by d.order_no
