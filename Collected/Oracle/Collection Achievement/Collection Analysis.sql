SELECT H.YEAR,
       H.PERIOD,
       H.SHOP_CODE,
       H.ORIGINAL_ACCT_NO,
       H.ACCT_NO,
       TO_CHAR(H.ACTUAL_SALES_DATE, 'MM/DD/YYYY') ACTUAL_SALES_DATE,
       TO_CHAR(H.SALES_DATE, 'MM/DD/YYYY') SALES_DATE,
       TO_CHAR(H.CASH_CONVERSION_ON_DATE, 'MM/DD/YYYY') CASH_CONVERSION_ON_DATE,
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
       /*(H.ACT_OUT_BAL - H.ARR_AMT),*/
       CASE WHEN (H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
       ((trunc(MONTHS_BETWEEN(last_day(to_date('&YEAR_I' || '/' ||
                                               '&PERIOD' || '/1',
                                               'YYYY/MM/DD')),
                              H.ACTUAL_SALES_DATE)) - 1) * H.MONTHLY_PAY)) > 0
                              THEN
       (H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
       ((trunc(MONTHS_BETWEEN(last_day(to_date('&YEAR_I' || '/' ||
                                               '&PERIOD' || '/1',
                                               'YYYY/MM/DD')),
                              H.ACTUAL_SALES_DATE)) - 1) * H.MONTHLY_PAY)) 
                              ELSE 0 END ADV_AMT--,
       /*(H.ACT_OUT_BAL - H.ARR_AMT) DEL_AMT,
       H.MONTHLY_PAY - (H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
       ((trunc(MONTHS_BETWEEN(last_day(to_date('&YEAR_I' || '/' ||
                                               '&PERIOD' || '/1',
                                               'YYYY/MM/DD')),
                              H.ACTUAL_SALES_DATE)) - 1) * H.MONTHLY_PAY)) DEL_AMT,*/
       /*IFSAPP.GET_SBL_DEL_AMT(H.YEAR, H.PERIOD, H.ACCT_NO) DEL_AMT2,
       ((H.ACT_OUT_BAL - H.ARR_AMT) - IFSAPP.GET_SBL_DEL_AMT(H.YEAR, H.PERIOD, H.ACCT_NO)) DIFF*/
  FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H
 WHERE H.YEAR = '&YEAR_I'
   AND H.PERIOD = '&PERIOD'
   AND H.ACT_OUT_BAL > 0
   /*AND H.ARR_AMT > 0*/
   --AND H.LOC >= H.ARR_MON
   /*AND (H.ACT_OUT_BAL - H.ARR_AMT) <= H.MONTHLY_PAY*/
   /*AND (H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
       ((trunc(MONTHS_BETWEEN(last_day(to_date('&YEAR_I' || '/' ||
                                               '&PERIOD' || '/1',
                                               'YYYY/MM/DD')),
                              H.ACTUAL_SALES_DATE)) - 1) * H.MONTHLY_PAY)) > 0
   AND (H.HIRE_PRICE - H.FIRST_PAY - H.ACT_OUT_BAL -
       ((trunc(MONTHS_BETWEEN(last_day(to_date('&YEAR_I' || '/' ||
                                               '&PERIOD' || '/1',
                                               'YYYY/MM/DD')),
                              H.ACTUAL_SALES_DATE)) - 1) * H.MONTHLY_PAY)) >= H.MONTHLY_PAY*/
   /*AND ((H.ACT_OUT_BAL - H.ARR_AMT) - IFSAPP.GET_SBL_DEL_AMT(H.YEAR, H.PERIOD, H.ACCT_NO)) != 0*/
 ORDER BY H.YEAR, H.PERIOD, H.SHOP_CODE, H.ORIGINAL_ACCT_NO
