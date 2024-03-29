select P.SHOP_CODE,
       P.ORIGINAL_ACCT_NO,
       TO_CHAR(P.ACTUAL_SALES_DATE, 'YYYY/MM/DD') ACTUAL_SALES_DATE,
       P.CUSTOMER_NAME,
       P.TEL_NO,
       P.ARR_AMT,
       P.ACT_OUT_BAL CURR_MON_OPEN_BAL,
       P.MONTHLY_PAY,
       P.ACC_STATUS CURR_ACC_STATUS,
       P.ADVANCE_AMOUNT,
       P.CURR_MONTH_PAYMENT,
       TO_CHAR(P.LAST_payment_date, 'YYYY/MM/DD') LAST_payment_date,
       CASE
         WHEN P.ACC_STATUS = 'Active' AND
              P.MONTHLY_PAY > (P.ADVANCE_AMOUNT + P.CURR_MONTH_PAYMENT) THEN
          'NON-PAYING'
         WHEN P.ACC_STATUS = 'DiscountClosed' AND P.CURR_MONTH_PAYMENT = 0 THEN
          'NON-PAYING'
         ELSE
          'PAYING'
       END PAYING_STATUS
  from IFSAPP.SBL_PAYING_ACC_LIST P
 WHERE P.SHOP_CODE IN
       (select U.CONTRACT
          from IFSAPP.USER_ALLOWED_SITE U
         where U.USERID = ifsapp.fnd_session_api.Get_Fnd_User)
   AND P.SHOP_CODE LIKE '&SHOP_CODE'
ORDER BY 2