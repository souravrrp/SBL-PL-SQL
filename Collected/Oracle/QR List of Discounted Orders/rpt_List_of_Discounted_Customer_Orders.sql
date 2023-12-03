--List of Discounted Customer Orders
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
       d.discount_amount,
       d.calculation_basis Base_Sale_Unit_Price,
       d.price_currency Sale_Price,
       d.remarks,
       to_char(trunc(d.rowversion), 'YYYY/MM/DD') discount_date
  from IFSAPP.CUST_ORDER_LINE_DISCOUNT_TAB d
 where trunc(d.rowversion) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and ifsapp.customer_order_line_api.Get_Contract(d.order_no,
                                                   d.line_no,
                                                   d.rel_no,
                                                   d.line_item_no) like '&shop_code'
   and d.discount_type like '&discount_type' --'SC-%' --in (''SC-EID SURPRISE OFFER', ''SC-SUPER SIX OFFER', 'MD-DENT/DMGD PRODUCT', 'MD', 'CL-CTV CLEARANCE DISCOUNT', 'MD-REV REFIX', 'SC-SAMSUNG EID POWER PLAY', 'SC-SAVE AND WIN EID')
   AND D.ORDER_NO not in (select ORDER_NO
                            from HPNRET_CUSTOMER_ORDER_TAB r
                           where r.ORDER_NO = D.ORDER_NO
                             and r.CASH_CONV = 'TRUE')   
   /*and ifsapp.customer_order_line_api.Get_Catalog_No(d.order_no,
                                                     d.line_no,
                                                     d.rel_no,
                                                     d.line_item_no) like
       '%REF%'*/
 order by d.order_no
