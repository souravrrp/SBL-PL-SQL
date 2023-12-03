--Wholesale or Corporate Dealerwise Product Sales Summary (Monthly)
SELECT EXTRACT(YEAR FROM W.SALES_DATE) "YEAR",
       EXTRACT(MONTH FROM W.SALES_DATE) PERIOD,
       W.CUSTOMER_NO DEALER_ID,
       W.CUSTOMER_NAME DEALER_NAME,
       W.PRODUCT_CODE,
       P.PRODUCT_FAMILY,
       P.BRAND,
       sum(W.SALES_QUANTITY) TOTAL_SALES_QUANTITY,
       sum(W.SALES_PRICE) TOTAL_SALES_PRICE
  FROM ifsapp.sbl_vw_wholesale_sales W
 INNER JOIN IFSAPP.SBL_JR_PRODUCT_DTL_INFO P
    ON W.PRODUCT_CODE = P.PRODUCT_CODE
 WHERE W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and W.SALES_PRICE != 0
   and W.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM')
       /*= 'SCSM'*/
   /*and W.CUSTOMER_NO = 'I0000500-1'*/
   AND P.PRODUCT_FAMILY IN ('REFRIGERATOR-DIRECT-COOL',
                            'REFRIGERATOR-SIDE-BY-SIDE',
                            'REFRIGERATOR-NOFROST',
                            'REFRIGERATOR-FREEZER',
                            'REFRIGERATOR-SEMI-COMM') /*= 'TV-PANEL'*/
   /*AND P.BRAND = 'Samsung'*/
   /*AND P.PRODUCT_CODE = 'SRSM-SME-1408'*/ /*'SRSM-SS-HEAD-15CH1'*/
       /*IN ('SRSM-SS-HEAD-15CH1',
           'PK-SM-15CH1-WT-WC',
           'PK-SM-15CH1-WT',
           'PK-SM-15CH1-HA',
           'SRSM-ZJ9513-G',
           'SRSM-SME-1408')*/
 group by EXTRACT(YEAR FROM W.SALES_DATE),
          EXTRACT(MONTH FROM W.SALES_DATE),
          W.CUSTOMER_NO,
          W.CUSTOMER_NAME,
          P.PRODUCT_FAMILY,
          P.BRAND,
          W.PRODUCT_CODE
 order by 1, 2, 3, 6, 7, 5

--*****Parameter Values
--Product Family
/*'REFRIGERATOR-DIRECT-COOL',
'REFRIGERATOR-SIDE-BY-SIDE',
'REFRIGERATOR-NOFROST',
'REFRIGERATOR-FREEZER',
'REFRIGERATOR-SEMI-COMM',
'TV-PANEL'
'OVEN-ELECTRICWAVE', 
'OVEN-MICROWAVE', 
'WASHING-MACHINE-TOP-LOADER', 
'RICE-COOKER'*/

--Brand
/*Samsung
Beko*/

--Part No
/*SRSM-SME-1408
SRSM-ZJ9513-G
SRSM-SS-HEAD-15CH1
PK-SM-15CH1-WT-WC
PK-SM-15CH1-WT
PK-SM-15CH1-HA*/
