--Employee & HO Sales
SELECT W.SITE,
       W.ORDER_NO,
       TO_CHAR(W.SALES_DATE, 'YYYY/MM/DD') SALES_DATE,
       W.CUSTOMER_NO,
       W.CUSTOMER_NAME,
       W.DELIVERY_SITE,
       W.PRODUCT_CODE,
       W.SALES_QUANTITY,
       W.SALES_PRICE,
       W.DISCOUNT "DISCOUNT(%)",
       W.VAT,
       W.unit_nsp,
       W.RSP "AMOUNT(RSP)"
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.SALES_DATE between to_date('&FROM_DATE', 'yyyy/mm/dd') and
       to_date('&TO_DATE', 'yyyy/mm/dd')
   and W.SITE in ('SESM', 'SHOM')
   AND W.CUSTOMER_NO LIKE '&CUSTOMER_ID'
 ORDER BY W.ORDER_NO, W.LINE_NO, W.REL_NO
