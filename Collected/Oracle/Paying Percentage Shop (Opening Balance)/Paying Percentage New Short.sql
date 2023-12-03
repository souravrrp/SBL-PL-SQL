SELECT HP.YEAR, --Opening Balance for the month
       HP.PERIOD,
       HP.SHOP_CODE,
       HP.acct_no,
       HP.original_acct_no,
       HP.ACTUAL_SALES_DATE,
       HP.SALES_DATE,
       HP.CLOSED_DATE,
       HP.STATE,
       HP.LAST_VARIATION,
       HP.MONTHLY_PAY,
       HP.COLLECTION,
       HP.LOC,
       HP.DISCOUNT,
       HP.ARR_AMT,
       HP.ARR_MON,
       HP.ACT_OUT_BAL
  from IFSAPP.hpnret_form249_arrears_tab HP
 where HP.YEAR = EXTRACT(YEAR FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                      'YYYY/MM/DD') - 1))
   AND HP.PERIOD = EXTRACT(MONTH FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                        'YYYY/MM/DD') - 1))
   AND HP.ACT_OUT_BAL > 0
  LEFT JOIN (SELECT HC.YEAR, --Closing Balance for the month
                    HC.PERIOD,
                    HC.SHOP_CODE,
                    HC.acct_no,
                    HC.original_acct_no,
                    HC.ACTUAL_SALES_DATE,
                    HC.SALES_DATE,
                    HC.CLOSED_DATE,
                    HC.STATE,
                    HC.LAST_VARIATION,
                    HC.MONTHLY_PAY,
                    HC.COLLECTION,
                    HC.LOC,
                    HC.DISCOUNT,
                    HC.ARR_AMT,
                    HC.ARR_MON,
                    HC.ACT_OUT_BAL
               from IFSAPP.hpnret_form249_arrears_tab HC
              where HC.YEAR = '&YEAR'
                AND HC.PERIOD = '&MONTH') CLB
    ON OPB.SHOP_CODE = CLB.SHOP_CODE
   AND OPB.acct_no = CLB.acct_no
   AND OPB.original_acct_no = CLB.original_acct_no
   AND OPB.ACTUAL_SALES_DATE = CLB.ACTUAL_SALES_DATE
   AND OPB.SALES_DATE = CLB.SALES_DATE
