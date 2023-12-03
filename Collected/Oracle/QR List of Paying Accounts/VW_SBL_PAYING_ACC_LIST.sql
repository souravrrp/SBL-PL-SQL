CREATE OR REPLACE VIEW SBL_PAYING_ACC_LIST AS
SELECT H.SHOP_CODE,
       H.ORIGINAL_ACCT_NO,
       H.ACCT_NO,
       H.ACTUAL_SALES_DATE,
       H.SALES_DATE,
       (TRUNC(SYSDATE, 'MM') - 1) CUT_OFF,
       (TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1, H.ACTUAL_SALES_DATE)) - 1) AGE_MONTH,
       H.CUSTOMER,
       IFSAPP.CUSTOMER_INFO_API.Get_Name(H.CUSTOMER) CUSTOMER_NAME,
       H.TEL_NO,
       H.HIRE_PRICE,
       H.FIRST_PAY,
       H.LOC,
       H.MONTHLY_PAY,
       H.DEL_MON,
       H.ARR_MON,
       H.ARR_AMT,
       H.ACT_OUT_BAL,
       (SELECT D.ROWSTATE
          FROM IFSAPP.HPNRET_HP_DTL_TAB D
         WHERE D.ACCOUNT_NO = H.ACCT_NO
           AND D.CASH_PRICE != 0
           AND ROWNUM <= 1) ACC_STATUS,
       (SELECT TRUNC(D.CLOSED_DATE)
          FROM IFSAPP.HPNRET_HP_DTL_TAB D
         WHERE D.ACCOUNT_NO = H.ACCT_NO
           AND D.CASH_PRICE != 0
           AND ROWNUM <= 1) CLOSED_DATE,
       CASE
         WHEN H.LOC >
              (TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                    H.ACTUAL_SALES_DATE)) - 1) AND
              (TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                    H.ACTUAL_SALES_DATE)) - 1) > 0 AND
              H.ARR_AMT = 0 THEN
          (CASE
            WHEN ((H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
                 ((TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                          H.ACTUAL_SALES_DATE)) - 1) *
                 H.MONTHLY_PAY))) > 0 THEN
             (H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
             ((TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                     H.ACTUAL_SALES_DATE)) - 1) *
             H.MONTHLY_PAY))
            ELSE
             0
          END)
         WHEN (TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                    H.ACTUAL_SALES_DATE)) - 1) <= 0 THEN
          H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL
         ELSE
          0
       END ADVANCE_AMOUNT,
       NVL(P.CURR_MONTH_PAYMENT, 0) CURR_MONTH_PAYMENT,
       P.LAST_payment_date,
       CASE
         WHEN (SELECT D.ROWSTATE
                 FROM IFSAPP.HPNRET_HP_DTL_TAB D
                WHERE D.ACCOUNT_NO = H.ACCT_NO
                  AND D.CASH_PRICE != 0
                  AND ROWNUM <= 1) = 'Active' and
              H.MONTHLY_PAY > (CASE
                WHEN H.LOC >
                     (TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                           H.ACTUAL_SALES_DATE)) - 1) AND
                     (TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                           H.ACTUAL_SALES_DATE)) - 1) > 0 AND
                     H.ARR_AMT = 0 THEN
                 (CASE
                   WHEN ((H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
                        ((TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                                 H.ACTUAL_SALES_DATE)) - 1) *
                        H.MONTHLY_PAY))) > 0 THEN
                    (H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
                    ((TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                            H.ACTUAL_SALES_DATE)) - 1) *
                    H.MONTHLY_PAY))
                   ELSE
                    0
                 END)
                WHEN (TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE, 'MM') - 1,
                                           H.ACTUAL_SALES_DATE)) - 1) <= 0 THEN
                 H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL
                ELSE
                 0
              END) + NVL(P.CURR_MONTH_PAYMENT, 0) THEN
          'NON-PAYING'
         WHEN (SELECT D.ROWSTATE
                 FROM IFSAPP.HPNRET_HP_DTL_TAB D
                WHERE D.ACCOUNT_NO = H.ACCT_NO
                  AND D.CASH_PRICE != 0
                  AND ROWNUM <= 1) = 'DiscountClosed' and EXISTS
          (select AU.account_no --Write Off List from HP Authorization
                 from IFSAPP.HPNRET_AUTH_VARIATION AU
                where AU.variation_db = 1
                  and AU.utilized = 1
                  and AU.account_no = H.ORIGINAL_ACCT_NO) THEN
          'NON-PAYING'
         ELSE
          'PAYING'
       END PAYING_STATUS
  FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H
  LEFT JOIN (SELECT C.contract,
                    C.account_no,
                    C.original_acc_no,
                    MAX(C.payment_date) LAST_payment_date,
                    SUM(C.amount) CURR_MONTH_PAYMENT
               FROM IFSAPP.SBL_COLLECTION_INFO C
              WHERE C.payment_date BETWEEN TRUNC(SYSDATE, 'MM') AND SYSDATE
              GROUP BY C.contract, C.account_no, C.original_acc_no) P
    ON H.SHOP_CODE = P.contract
   AND H.ORIGINAL_ACCT_NO = P.original_acc_no
   AND H.ACCT_NO = P.account_no
 WHERE H.YEAR = EXTRACT(YEAR FROM(TRUNC(SYSDATE, 'MM') - 1))
   AND H.PERIOD = EXTRACT(MONTH FROM(TRUNC(SYSDATE, 'MM') - 1))
   AND H.ACT_OUT_BAL > 0;
