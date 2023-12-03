SELECT 
    /*COUNT(*)*/
    H.YEAR,
    H.PERIOD,
    (select sdi.area_code from SHOP_DTS_INFO sdi WHERE SDI.SHOP_CODE = H.SHOP_CODE) area_code,
    (select sdi.District_Code from SHOP_DTS_INFO sdi WHERE SDI.SHOP_CODE = H.SHOP_CODE) District_Code,
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
    H.RED_DEL,
    H.ACT_OUT_BAL
FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H
WHERE H.ACT_OUT_BAL > 0 AND
  H.YEAR = '&year_i' AND
  H.PERIOD = '&month_i' AND
  H.SHOP_CODE IN (select sdi.Shop_Code from SHOP_DTS_INFO sdi WHERE sdi.area_code like '%&area_code%') and
  --H.SHOP_CODE IN (select sdi.Shop_Code from SHOP_DTS_INFO sdi WHERE sdi.district_code = '&district_code') and
  --H.SHOP_CODE LIKE '&shop_code' AND 
  H.RED_DEL = 'Y'
ORDER BY area_code, District_Code, H.SHOP_CODE, H.ACCT_NO, H.PRODUCT_CODE
  
