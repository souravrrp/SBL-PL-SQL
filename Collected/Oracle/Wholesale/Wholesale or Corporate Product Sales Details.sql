--Wholesale or Corporate Product Sales Details
SELECT W.SITE,
       W.ORDER_NO,
       W.LINE_NO,
       W.REL_NO,
       TO_CHAR(W.SALES_DATE, 'YYYY/MM/DD') SALES_DATE,
       W.DELIVERY_SITE,
       W.PRODUCT_CODE,
       W.PRODUCT_DESC,
       P.PRODUCT_FAMILY,
       W.CUSTOMER_NO DEALER_ID,
       W.CUSTOMER_NAME DEALER_NAME,
       W.SALES_QUANTITY,
       W.SALES_PRICE,
       W.DISCOUNT "DISCOUNT(%)",
       W.VAT,
       W.unit_nsp,
       W.RSP "AMOUNT(RSP)"
  FROM ifsapp.sbl_vw_wholesale_sales W
 INNER JOIN IFSAPP.SBL_JR_PRODUCT_DTL_INFO P
    ON W.PRODUCT_CODE = P.PRODUCT_CODE
 WHERE W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and W.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO') /*= 'SCSM'*/
   /*AND P.PRODUCT_FAMILY \*IN ('REFRIGERATOR-DIRECT-COOL',
                            'REFRIGERATOR-SIDE-BY-SIDE',
                            'REFRIGERATOR-NOFROST',
                            'REFRIGERATOR-FREEZER',
                            'REFRIGERATOR-SEMI-COMM',
                            'TV-PANEL')*\ = 'GAS-BURNER'*/
   /*AND P.BRAND = 'Samsung'*/
   AND P.PRODUCT_CODE = 'SRSM-SME-1408'
 ORDER BY 2, 3, 4

--*****Parameter Values
--Product Family
/*'REFRIGERATOR-DIRECT-COOL',
'REFRIGERATOR-SIDE-BY-SIDE',
'REFRIGERATOR-NOFROST',
'REFRIGERATOR-FREEZER',
'REFRIGERATOR-SEMI-COMM',
'TV-PANEL'*/

--Brand
/*Samsung
Beko
Pureit*/

--Part No
/*SRSM-SME-1408*/
/*'SRSM-SS-HEAD-15CH1', 'PK-SM-15CH1-WT-WC', 'PK-SM-15CH1-WT', 'PK-SM-15CH1-HA'*/
