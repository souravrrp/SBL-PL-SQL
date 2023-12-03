select ifsapp.customer_order_line_api.Get_Catalog_No(d.order_no,
                                                     d.line_no,
                                                     d.rel_no,
                                                     d.line_item_no) Catalog_No,
       d.discount_type,
       sum(d.calculation_basis) total_Base_Sale_Unit_Price,
       sum(d.discount_amount) total_discount_amount,
       sum(d.price_currency) total_Sale_Price
  from CUST_ORDER_LINE_DISCOUNT_TAB d
 where trunc(d.rowversion) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
      --and d.discount_type like 'SC-%' --in (''SC-EID SURPRISE OFFER', ''SC-SUPER SIX OFFER', 'MD-DENT/DMGD PRODUCT', 'MD', 'CL-CTV CLEARANCE DISCOUNT', 'MD-REV REFIX', 'SC-SAMSUNG EID POWER PLAY', 'SC-SAVE AND WIN EID')
   AND D.ORDER_NO not in (select ORDER_NO
                            from HPNRET_CUSTOMER_ORDER_TAB r
                           where r.ORDER_NO = D.ORDER_NO
                             and r.CASH_CONV = 'TRUE')
   and ifsapp.customer_order_line_api.Get_Catalog_No(d.order_no,
                                                     d.line_no,
                                                     d.rel_no,
                                                     d.line_item_no) like
       '%FUR%'
 group by ifsapp.customer_order_line_api.Get_Catalog_No(d.order_no,
                                                        d.line_no,
                                                        d.rel_no,
                                                        d.line_item_no),
          d.discount_type
 order by ifsapp.customer_order_line_api.Get_Catalog_No(d.order_no,
                                                        d.line_no,
                                                        d.rel_no,
                                                        d.line_item_no),
          d.discount_type
