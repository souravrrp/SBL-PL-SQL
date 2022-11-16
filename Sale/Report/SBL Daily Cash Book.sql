/* Formatted on 8/22/2022 3:21:56 PM (QP5 v5.381) */
  SELECT JJ.sales_date,
         JJ.order_no     ACCOUNT_NO,
         JJ.status       ACCOUNT_STATUS,
         JJ.product_code,
         DI.PRODUCT_DESC,
         JJ.sales_quantity,
         JJ.sales_price,
         JJ.amount_rsp
    FROM IFSAPP.SBL_JR_SALES_INV_COMP_VIEW JJ,
         IFSAPP.SBL_JR_PRODUCT_DTL_INFO   DI
   WHERE     JJ.sales_date BETWEEN :P_From_Date AND :P_To_Date
         AND JJ.PRODUCT_CODE = DI.PRODUCT_CODE
         AND SUBSTR (JJ.order_no, 4, 2) IN ('-H', '-R')
         AND JJ.status != 'PositiveCashConv'
         AND JJ.SHOP_CODE = :P_Site_Code
ORDER BY JJ.sales_date, JJ.order_no, JJ.product_code