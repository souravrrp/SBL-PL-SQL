/* Formatted on 7/3/2022 4:07:55 PM (QP5 v5.381) */
  SELECT SDI.CUSTOMER_ID,
         sdi.NAME,
         H.ACCT_NO,
         H.PRODUCT_CODE,
         H.SALES_DATE,
         SUM (H.MONTHLY_PAY)                MONTHLY_PAY,
         TRUNC (AVG (H.ARR_MON), 2)         AVG_ARR_MON,
         TRUNC (SUM (H.ARR_AMT), 2)         SUM_ARR_AMT,
         TRUNC (AVG (H.DEL_MON), 2)         AVG_DEL_MON,
         H.RED_DEL,
         TRUNC (SUM (H.ACT_OUT_BAL), 2)     SUM_ACT_OUT_BAL
    FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H, ifsapp.customer_info_tab sdi
   WHERE     H.ACT_OUT_BAL > 0
         AND SDI.CUSTOMER_ID = H.CUSTOMER
         AND H.RED_DEL = 'Y'
GROUP BY SDI.CUSTOMER_ID,
         sdi.NAME,
         H.ACCT_NO,
         H.PRODUCT_CODE,
         H.SALES_DATE,
         H.RED_DEL
ORDER BY sdi.NAME