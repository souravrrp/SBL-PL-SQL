select T.*,
       (SELECT H.CUSTOMER
          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H
         WHERE H.YEAR = T.YEAR
           AND H.PERIOD = T.PERIOD
           AND H.SHOP_CODE = T.SHOP_CODE
           AND H.ACCT_NO = T.ACCT_NO) CUSTOMER
  from IFSAPP.SBL_ECC_FORWARD_AGING t
 where t.year = '&year'
   and t.period = '&period'
