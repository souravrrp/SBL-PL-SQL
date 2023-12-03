SELECT H.YEAR,
       H.PERIOD,
       H.ACCT_NO,
       H.PRODUCT_CODE,
       H.CUSTOMER,
       IFSAPP.customer_info_api.Get_Name(H.CUSTOMER) CUSTOMER_NAME,
       TO_CHAR(H.SALES_DATE, 'MM/DD/YYYY') SALES_DATE,
       H.AMOUNT_FINANCED,
       H.MONTHLY_PAY,
       H.LOC,
       H.TOTAL_UCC,
       H.ACT_OUT_BAL,
       H.ARR_MON ARREAR_MONTH,
       TO_CHAR(H.CASH_CONVERSION_ON_DATE, 'MM/DD/YYYY') CASH_CONVERSION_ON_DATE,
       H.EFFECTIVE_RATE,
       H.PRESENT_VALUE,
       H.EFFECTIVE_ECC,
       H.ACTUAL_UCC
  FROM HPNRET_FORM249_ARREARS_TAB H
 WHERE H.YEAR = '&year_i'
   AND H.PERIOD = '&period_i'
   AND H.ACT_OUT_BAL > 0
   AND TRUNC(H.CASH_CONVERSION_ON_DATE) > --<=
       TO_DATE('&cut_off_date', 'YYYY/MM/DD')
   --AND H.ACCT_NO != 'DBL-H2291'
