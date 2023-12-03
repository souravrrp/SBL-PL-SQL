SELECT W.SITE CONTRACT,
       W.ORDER_NO,
       C.PAY_TERM_ID,
       W.series_id,
       W.invoice_no,
       TO_CHAR(W.SALES_DATE, 'YYYY/MM/DD') SALE_DATE,
       W.DELIVERY_SITE VENDOR_NO,
       W.CUSTOMER_NO,
       W.CUSTOMER_NAME,
       W.PRODUCT_CODE CATALOG_NO,
       W.SALES_QUANTITY QTY_SHIPPED,
       W.SALES_PRICE SALE_PRICE,
       W.DISCOUNT,
       W.VAT TAX_AMOUNT,
       W.RSP "AMOUNT(RSP)"
  FROM ifsapp.sbl_vw_wholesale_sales W, ifsapp.customer_order_tab c
 WHERE W.ORDER_NO = C.ORDER_NO
   AND W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and W.SITE in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO') 
   AND W.CUSTOMER_NO LIKE '&CUSTOMER_ID'
   and W.SALES_PRICE >= 0
   AND C.PAY_TERM_ID LIKE 'CR%'
 ORDER BY W.SITE, W.ORDER_NO
