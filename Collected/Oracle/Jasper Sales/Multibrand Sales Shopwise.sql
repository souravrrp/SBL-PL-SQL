--Multi-Brand Sales Shopwise
SELECT R.SHOP_CODE,
       R.AREA_CODE,
       R.DISTRICT_CODE,
       R.ORDER_NO,
       R.SALES_DATE,
       R.Status,
       R.PRODUCT_CODE,
       P.PRODUCT_FAMILY,
       P.BRAND,
       R.SALES_QUANTITY,
       R.SALES_PRICE,
       R.AMOUNT_RSP
  FROM IFSAPP.SBL_JR_SALES_INV_COMP_VIEW R,
       IFSAPP.SBL_JR_PRODUCT_DTL_INFO    P
 WHERE R.PRODUCT_CODE = P.PRODUCT_CODE
   AND R.SALES_DATE BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND P.BRAND NOT IN ('Singer', 'Merritt', 'Singtech', 'Sinotec')
   AND P.PRODUCT_FAMILY NOT IN (/*'MONITOR',*/'GIFT', 'Raw Material') /*= 'COMPUTER-DESKTOP'*/
   AND P.PRODUCT_CODE != 'SGCOM-LED-18.5'
   and R.Status not in ('CashConverted', 'PositiveCashConv')
   /*AND R.SHOP_CODE = 'ISDB'*/
   /*AND R.ORDER_NO = 'ISD-H3613'*/
 ORDER BY 2, 3, 1, 4
