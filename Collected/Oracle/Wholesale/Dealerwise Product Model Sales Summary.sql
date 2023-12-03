--Wholesale Dealerwise Product Model Sales Summary (Date Range)
SELECT W.CUSTOMER_NO DEALER_ID,
       W.CUSTOMER_NAME DEALER_NAME,
       W.PRODUCT_CODE,
       P.PRODUCT_FAMILY,
       /*'REF' PRODUCT,*/
       sum(W.SALES_QUANTITY) TOTAL_SALES_QUANTITY,
       sum(W.SALES_PRICE) TOTAL_SALES_PRICE
  FROM ifsapp.sbl_vw_wholesale_sales W
 INNER JOIN IFSAPP.SBL_JR_PRODUCT_DTL_INFO P
    ON W.PRODUCT_CODE = P.PRODUCT_CODE
 WHERE W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   AND W.SALES_PRICE != 0
   and W.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') /*= 'SCSM'*/
   AND P.PRODUCT_FAMILY = 'AIR-CONDITIONER' /*IN
       ('REFRIGERATOR-DIRECT-COOL',
        'REFRIGERATOR-SIDE-BY-SIDE',
        'REFRIGERATOR-NOFROST',
        'REFRIGERATOR-FREEZER',
        'REFRIGERATOR-SEMI-COMM')*/
   /*AND P.BRAND = 'Preethi'*/
   /*AND P.PRODUCT_CODE IN ('SRSM-SS-HEAD-15CH1',
                          'PK-SM-15CH1-WT-WC',
                          'PK-SM-15CH1-WT',
                          'PK-SM-15CH1-HA',
                          'SRSM-ZJ9513-G',
                          'SRSM-SME-1408')*/ /*= 'SRSM-ZJ9513-G'*/ /*LIKE '%REF-%'*/
 group by W.CUSTOMER_NO, W.CUSTOMER_NAME, W.PRODUCT_CODE, P.PRODUCT_FAMILY
 order by 1, 2, 4, 3

--******
/*Product Models
SRSM-SME-1408
'SRSM-SS-HEAD-15CH1', 'SRSM-SME-1408', 'PK-SM-15CH1-WT-WC', 'PK-SM-15CH1-WT', 'PK-SM-15CH1-HA'
*/
