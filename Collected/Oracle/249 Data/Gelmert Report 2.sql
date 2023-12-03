SELECT H.YEAR,
       H.PERIOD,
       H.ACCT_NO,
       H.CUSTOMER,
       IFSAPP.CUSTOMER_INFO_API.Get_Name(H.CUSTOMER) CUSTOMER_NAME,
       --H.ARR_MON,
       case when H.ARR_MON > 12 then
         '12+'
       else
         to_char(H.ARR_MON)
       end ARR_MON,
       case when CEIL(H.ARR_AMT / H.MONTHLY_PAY) > 12 then
          '12+'
         else
          to_char(CEIL(H.ARR_AMT / H.MONTHLY_PAY))
       end NO_OF_MON_IN_ARR,
       --H.DEL_MON,
       case when H.DEL_MON > 12 then
          '12+'
         else
          to_char(H.DEL_MON)
       end DEL_MON,
       H.ACT_OUT_BAL,
       H.PRESENT_VALUE--,
       --H.ACTUAL_UCC
  FROM HPNRET_FORM249_ARREARS_TAB H
 WHERE H.YEAR = '&YEAR_I'
   AND H.PERIOD = '&PERIOD'
   AND H.ACT_OUT_BAL > 0
   AND H.MONTHLY_PAY <> 0
   /*and H.ACCT_NO != 'DBL-H2291'*/