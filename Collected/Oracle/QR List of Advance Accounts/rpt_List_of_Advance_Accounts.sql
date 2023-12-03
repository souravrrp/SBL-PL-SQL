--List of Advance Accounts
SELECT H.YEAR,
       H.PERIOD,
       H.SHOP_CODE,
       H.ORIGINAL_ACCT_NO,
       H.ACCT_NO,
       H.PRODUCT_CODE,
       H.SALESMAN,
       TO_CHAR(H.ACTUAL_SALES_DATE, 'YYYY/MM/DD') ACTUAL_SALES_DATE,
       TO_CHAR(H.SALES_DATE, 'YYYY/MM/DD') SALES_DATE,
       H.CUSTOMER,
       H.NORMAL_CASH_PRICE CASH_PRICE,
       H.HIRE_CASH_PRICE,
       H.HIRE_PRICE,
       H.AMOUNT_FINANCED,
       H.MONTHLY_PAY,
       H.FIRST_PAY,
       H.DOWN_PAYMENT,
       H.LOC,
       H.ARR_MON,
       H.ARR_AMT,
       H.DEL_MON,
       H.ACT_OUT_BAL,
       CASE
         WHEN (H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
              (FLOOR(MONTHS_BETWEEN(last_day(to_date(H.YEAR || '/' ||
                                                      H.PERIOD || '/1',
                                                      'YYYY/MM/DD')),
                                     (H.ACTUAL_SALES_DATE +
                                     (NVL((select B.GRACE_PERIOD
                                             from IFSAPP.HPNRET_BB_MAIN_HEAD_TAB B
                                            where B.BUDGET_BOOK_ID = H.BB_NO),
                                           0))))) * H.MONTHLY_PAY)) > 0 THEN
          (H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
          (FLOOR(MONTHS_BETWEEN(last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                                  'YYYY/MM/DD')),
                                 (H.ACTUAL_SALES_DATE +
                                 (NVL((select B.GRACE_PERIOD
                                         from IFSAPP.HPNRET_BB_MAIN_HEAD_TAB B
                                        where B.BUDGET_BOOK_ID = H.BB_NO),
                                       0))))) * H.MONTHLY_PAY))
         ELSE
          0
       END ADVANCE_AMOUNT
/*(H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
((trunc(MONTHS_BETWEEN(last_day(to_date('&year_i' || '/' ||
                                        '&month_i' || '/1',
                                        'YYYY/MM/DD')),
                       H.ACTUAL_SALES_DATE)) - 1) * H.MONTHLY_PAY)) ADVANCE_AMOUNT*/
  FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H
 WHERE H.YEAR = '&year_i'
   AND H.PERIOD = '&month_i'
   AND H.SHOP_CODE LIKE '&shop_code'
   AND H.ACT_OUT_BAL > 0
   AND H.ARR_MON = 0
   AND H.ARR_AMT = 0
 ORDER BY H.SHOP_CODE, H.ACCT_NO, H.PRODUCT_CODE
