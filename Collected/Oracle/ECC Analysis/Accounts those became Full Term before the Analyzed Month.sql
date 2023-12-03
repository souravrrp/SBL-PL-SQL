--Accounts those became Full Term before the Analyzed Month (ie. Cash Conversion Date < First Day of Analyzed Month)
SELECT H1.YEAR,
       H1.PERIOD,
       H1.SHOP_CODE,
       H1.ORIGINAL_ACCT_NO,
       H1.ACCT_NO,
       H1.PRODUCT_CODE,
       H1.MORE_PRODUCTS,
       H1.SALESMAN,
       H1.SALES_CREATOR,
       H1.HP_TYPE,
       H1.ACTUAL_SALES_DATE,
       H1.SALES_DATE,
       H1.REAL_SHIP_DATE,
       H1.CLOSED_DATE,
       H1.STATE,
       H1.LAST_VARIATION,
       H1.BB_NO,
       H1.SCHEME,
       H1.GROUP_SALE_NO,
       H1.CUSTOMER,
       H1.ORDER_TYPE,
       H1.MC_CD,
       H1.NORMAL_CASH_PRICE,
       H1.HIRE_CASH_PRICE,
       H1.HIRE_PRICE,
       H1.LIST_PRICE,
       H1.AMOUNT_FINANCED,
       H1.MONTHLY_PAY,
       H1.FIRST_PAY,
       H1.DOWN_PAYMENT,
       H1.SURAKSHA_AMOUNT,
       H1.SANASUMA_AMOUNT,
       H1.COMMODITY2,
       H1.COLLECTION,
       H1.LOC,
       H1.DISCOUNT,
       H1.TOTAL_UCC,
       H1.ARR_AMT,
       H1.ARR_MON,
       H1.OUTSTANDING_BAL,
       H1.OUTSTANDING_MONTHS,
       H1.OUTSTANDING_UCC,
       REPLACE(H1.TEL_NO, ',', '_') TEL_NO,
       H1.DEL_MON,
       TRUNC(H1.ROWVERSION) ROWVERSION,
       H1.ACT_OUT_BAL,
       H1.VAT,
       H1.CASH_CONVERSION_ON_DATE,
       H.EFFECTIVE_RATE EFFECTIVE_RATE_P,
       H1.EFFECTIVE_RATE EFFECTIVE_RATE_N,
       H.PRESENT_VALUE PRESENT_VALUE_P,
       H1.PRESENT_VALUE PRESENT_VALUE_N,
       H.ACTUAL_UCC ACTUAL_UCC_P,
       H1.ACTUAL_UCC ACTUAL_UCC_N,
       H.EFFECTIVE_ECC EFFECTIVE_ECC_P,
       H1.EFFECTIVE_ECC EFFECTIVE_ECC_N
  FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H, --Previous Month of the Analyzed Month
       IFSAPP.HPNRET_FORM249_ARREARS_TAB H1 --Analyzed Month
 WHERE H.ORIGINAL_ACCT_NO = H1.ORIGINAL_ACCT_NO
   AND H.ACCT_NO = H.ACCT_NO
   AND H.YEAR =
       EXTRACT(YEAR FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                  'YYYY/MM/DD'),
                          -1))
   AND H.PERIOD =
       EXTRACT(MONTH FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                  'YYYY/MM/DD'),
                          -1))
   AND H1.YEAR = '&YEAR_I' --Year of the Analyzed Month
   AND H1.PERIOD = '&PERIOD' --Period of the Analyzed Month
   AND H.ACT_OUT_BAL > 0
   AND H1.ACT_OUT_BAL > 0
   AND H1.CASH_CONVERSION_ON_DATE <
       TO_DATE('&YEAR_I' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD')
