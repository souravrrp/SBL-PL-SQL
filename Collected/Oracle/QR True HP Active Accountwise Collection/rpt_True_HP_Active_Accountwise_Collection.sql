SELECT H.YEAR,
       H.PERIOD,
       H.SHOP_CODE,
       H.ACCT_NO,
       H.PRODUCT_CODE,
       TO_CHAR(H.ACTUAL_SALES_DATE, 'YYYY/MM/DD') ACTUAL_SALES_DATE,
       IFSAPP.CUSTOMER_INFO_API.Get_Name(H.CUSTOMER) CUSTOMER_NAME,
       REPLACE(H.TEL_NO, ',', '_') TEL_NO,
       IFSAPP.CUSTOMER_INFO_API.Get_NIC_No(H.CUSTOMER) NIC_NO,
       H.MONTHLY_PAY,
       H.ACT_OUT_BAL,
       H.COLLECTION COLLECTION_AMT,
       H.ARR_AMT,
       to_char(h.cash_conversion_on_date, 'YYYY/MM/DD') cash_conversion_on_date
  FROM ifsapp.HPNRET_FORM249_ARREARS_TAB H
 WHERE H.YEAR = '&YEAR'
   AND H.PERIOD = '&PERIOD'
   AND H.SHOP_CODE LIKE '&SHOP_CODE'
   AND H.ACT_OUT_BAL > 0
   and trunc(h.cash_conversion_on_date) <
       to_date('&YEAR' || '/' || '&PERIOD' || '/01', 'YYYY/MM/DD')
 ORDER BY H.SHOP_CODE, H.ACCT_NO
