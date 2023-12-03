SELECT /*W.SITE,
       W.ORDER_NO,
       W.LINE_NO,
       W.REL_NO,
       TO_CHAR(W.SALES_DATE, 'YYYY/MM/DD') SALES_DATE,*/
       W.CUSTOMER_NO,
       W.CUSTOMER_NAME,
       --W.creator,
       --W.CUSTOMER_GROUP,
       /*W.DELIVERY_SITE,
       W.PRODUCT_CODE,*/
       --W.PRODUCT_DESC,
       --W.CATALOG_TYPE,
       sum(W.SALES_QUANTITY) total_quantity,
       sum(W.SALES_PRICE) total_sales_price--,
       /*W.DISCOUNT       "DISCOUNT(%)",
       W.VAT,
       W.unit_nsp,
       W.RSP            "AMOUNT(RSP)"*/
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and W.SITE /*in ('JWSS', 'SAOS', 'SWSS', 'WSMO')*/ = 'SCSM'
   group by w.CUSTOMER_NO, w.CUSTOMER_NAME
   order by 2
