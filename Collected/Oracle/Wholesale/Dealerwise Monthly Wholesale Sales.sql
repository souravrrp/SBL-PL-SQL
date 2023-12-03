--Dealerwise monthly wholesale sales
SELECT EXTRACT(YEAR FROM W.SALES_DATE) "YEAR",
       EXTRACT(MONTH FROM W.SALES_DATE) PERIOD,
       W.CUSTOMER_NO DEALER_ID,
       W.CUSTOMER_NAME DEALER_NAME,
       sum(W.SALES_QUANTITY) total_quantity,
       sum(W.SALES_PRICE) total_sales_price
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and W.SITE in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
 group by EXTRACT(YEAR FROM W.SALES_DATE),
          EXTRACT(MONTH FROM W.SALES_DATE),
          W.CUSTOMER_NO,
          W.CUSTOMER_NAME
 order by 1,2,3,4
