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
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             ifsapp.customer_order_line_api.Get_Catalog_No(d.order_no,
                                                                                                                                                           d.line_no,
                                                                                                                                                           d.rel_no,
                                                                                                                                                           d.line_item_no))) product_family,
       d.discount_type,
       d.discount_amount,
       d.calculation_basis,
       d.price_currency Sale_Price,
       --d.price_base,
       d.remarks,
       trunc(d.rowversion) rowversion
  from IFSAPP.CUST_ORDER_LINE_DISCOUNT_TAB d
 where trunc(d.rowversion) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   AND D.ORDER_NO /*not*/ in (select ORDER_NO
                            from HPNRET_CUSTOMER_ORDER_TAB r
                           where r.ORDER_NO = D.ORDER_NO
                             and r.CASH_CONV = 'TRUE')
   /*and d.discount_type in
       ('GP-5 PERCENT-2018', 'ROBI-5 PERCENT-2018', 'GP-10 PERCENT-CLASIC-2018', 'GP-12 PERCENT-ULTIMA-2018')*/ /*like 'CR-MASTERCARD DISCOUNT'*/
/*'CR-MASTERCARD DISCOUNT',
'CR-CARD DISCOUNT',
'CR-SCB DISCOUNT',
'GP-5 PERCENT', 
'GP-10 PERCENT',
'GP-10 PERCENT-CLASIC-2018'
'GP-12 PERCENT-ULTIMA-2018'
'SC-EID SURPRISE OFFER',
'SC-SUPER SIX OFFER',
'MD-DENT/DMGD PRODUCT',
'MD',
'CL-CTV CLEARANCE DISCOUNT',
'MD-REV REFIX',
'SC-SAMSUNG EID POWER PLAY',
'SC-SAVE AND WIN EID'
'G-AC SMS CAMPAIGN'
'G-BANK EMPLOYEE'
'ROBI-5 PERCENT-2018'*/
/*and ifsapp.customer_order_line_api.Get_Contract(d.order_no,
d.line_no,
d.rel_no,
d.line_item_no) = 'DITF'*/
/*and ifsapp.customer_order_line_api.Get_Catalog_No(d.order_no,
                                              d.line_no,
                                              d.rel_no,
                                              d.line_item_no) like
'%REF%'*/
 order by d.order_no
