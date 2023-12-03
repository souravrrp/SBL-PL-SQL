SELECT 
    /*COUNT(*)*/
    --H.YEAR,
    --H.PERIOD,
    H.SHOP_CODE,
    H.ORIGINAL_ACCT_NO,
    H.ACCT_NO,
    H.PRODUCT_CODE,
    --H.MORE_PRODUCTS,
    H.SALESMAN,
    --H.SALES_CREATOR,
    --H.HP_TYPE,
    TO_CHAR(H.ACTUAL_SALES_DATE, 'MM/DD/YYYY') ACTUAL_SALES_DATE,
    TO_CHAR(H.SALES_DATE, 'MM/DD/YYYY') SALES_DATE,
    TO_CHAR(H.REAL_SHIP_DATE, 'MM/DD/YYYY') REAL_SHIP_DATE,
    --TO_CHAR(H.CLOSED_DATE, 'MM/DD/YYYY') CLOSED_DATE,
    (select distinct(to_CHAR(t.rowversion, 'MM/DD/YYYY')) 
      from HPNRET_HP_DTL_TAB t
      where t.account_no = H.ACCT_NO and t.rowstate = 'Reverted')REVERT_DATE ,
    H.STATE,
    --H.LAST_VARIATION,
    H.BB_NO,
    H.SCHEME,
    --H.GROUP_SALE_NO,
    H.CUSTOMER,
    H.ORDER_TYPE,
    H.MC_CD,
    H.NORMAL_CASH_PRICE,
    H.HIRE_CASH_PRICE,
    H.HIRE_PRICE,
    H.LIST_PRICE,
    H.AMOUNT_FINANCED,
    H.MONTHLY_PAY,
    H.FIRST_PAY,
    H.DOWN_PAYMENT,
    --H.SURAKSHA_AMOUNT,
    --H.SANASUMA_AMOUNT,
    --H.COMMODITY2,
    --H.COLLECTION,
    H.LOC,
    H.DISCOUNT,
    H.TOTAL_UCC,
    H.ARR_AMT,
    H.ARR_MON,
    H.OUTSTANDING_BAL,
    H.OUTSTANDING_MONTHS,
    H.OUTSTANDING_UCC,
    REPLACE(H.TEL_NO, ',', '_') TEL_NO,
    H.DEL_MON,
    to_char(H.ROWVERSION, 'MM/DD/YYYY') ROWVERSION,
    H.ACT_OUT_BAL,
    H.VAT,
    TO_CHAR(H.CASH_CONVERSION_ON_DATE, 'MM/DD/YYYY') CASH_CONVERSION_ON_DATE--,
    --H.EFFECTIVE_RATE,
    --H.PRESENT_VALUE,
    --H.ACTUAL_UCC,
    --H.EFFECTIVE_ECC
FROM HPNRET_FORM249_ARREARS_TAB H
WHERE H.YEAR = 2013 AND
  H.PERIOD = 12 and
  h.original_acct_no in (select distinct(t.account_no) 
      from HPNRET_HP_DTL_TAB t
      where t.rowstate in ('Reverted') and
        t.rowversion between to_date('2014/1/1', 'YYYY/MM/DD') and to_date('2014/2/1', 'YYYY/MM/DD'))
order by h.shop_code, h.acct_no
