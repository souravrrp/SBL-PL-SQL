SELECT 
    H.SHOP_CODE,
    count(H.ORIGINAL_ACCT_NO) NO_OF_HIRE_ACCOUNTS
FROM HPNRET_FORM249_ARREARS_TAB H
WHERE H.YEAR = '&YEAR_I' AND
  H.PERIOD = '&PERIOD' AND
  H.ACT_OUT_BAL > 0
group by h.shop_code
ORDER BY H.SHOP_CODE