CREATE OR REPLACE VIEW SBL_ADV_AMT_OF_HP_ACC AS
SELECT H.YEAR,
       H.PERIOD,
       H.SHOP_CODE,
       H.ORIGINAL_ACCT_NO,
       H.ACCT_NO,
       H.ACTUAL_SALES_DATE,
       H.SALES_DATE,
       H.CASH_CONVERSION_ON_DATE,
       H.BB_NO,
       H.HIRE_PRICE,
       H.LOC,
       H.FIRST_PAY,
       H.AMOUNT_FINANCED,
       H.MONTHLY_PAY,
       H.COLLECTION,
       H.ARR_MON,
       H.DEL_MON,
       H.ARR_AMT,
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
       END ADV_AMT
  FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H
 WHERE H.ACT_OUT_BAL > 0
 ORDER BY H.YEAR, H.PERIOD, H.SHOP_CODE, H.ORIGINAL_ACCT_NO;