--Original Data Set
SELECT *
  FROM (SELECT H1.YEAR, --Opening Balance
               H1.PERIOD,
               H.YEAR YEAR_P,
               H.PERIOD PERIOD_P,
               H1.ORIGINAL_ACCT_NO,
               H1.ACCT_NO,
               H1.SALES_DATE,
               H.ACT_OUT_BAL,
               H1.STATE,
               H1.LAST_VARIATION,
               H1.CASH_CONVERSION_ON_DATE
          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H,
               IFSAPP.HPNRET_FORM249_ARREARS_TAB H1
         WHERE H.ORIGINAL_ACCT_NO = H1.ORIGINAL_ACCT_NO
           AND H.ACCT_NO = H.ACCT_NO
           AND H.YEAR = EXTRACT(YEAR FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                   '&PERIOD' || '/1',
                                                   'YYYY/MM/DD'),
                                           -1))
           AND H.PERIOD = EXTRACT(MONTH FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                     '&PERIOD' || '/1',
                                                     'YYYY/MM/DD'),
                                             -1))
           AND H1.YEAR = '&YEAR_I'
           AND H1.PERIOD = '&PERIOD'
           AND H.ACT_OUT_BAL > 0
        
        UNION ALL
        
        SELECT H1.YEAR, --New Accounts
               H1.PERIOD,
               0                          "YEAR_P",
               0                          "PERIOD_P",
               H1.ORIGINAL_ACCT_NO,
               H1.ACCT_NO,
               H1.SALES_DATE,
               0                          ACT_OUT_BAL,
               H1.STATE,
               H1.LAST_VARIATION,
               H1.CASH_CONVERSION_ON_DATE
          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H1
         WHERE H1.YEAR = '&YEAR_I'
           AND H1.PERIOD = '&PERIOD'
           AND H1.STATE = 'Active'
           AND H1.SALES_DATE >= TO_DATE('&SALES_DATE', 'YYYY/MM/DD')) B

MINUS

--Queried Data Set
SELECT *
  FROM (SELECT H1.YEAR, --Regular Close Accounts
               H1.PERIOD,
               H.YEAR                     YEAR_P,
               H.PERIOD                   PERIOD_P,
               H1.ORIGINAL_ACCT_NO,
               H1.ACCT_NO,
               H1.SALES_DATE,
               H.ACT_OUT_BAL,
               H1.STATE,
               H1.LAST_VARIATION,
               H1.CASH_CONVERSION_ON_DATE
          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H,
               IFSAPP.HPNRET_FORM249_ARREARS_TAB H1
         WHERE H.ORIGINAL_ACCT_NO = H1.ORIGINAL_ACCT_NO
           AND H.ACCT_NO = H.ACCT_NO
           AND H.YEAR = EXTRACT(YEAR FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                   '&PERIOD' || '/1',
                                                   'YYYY/MM/DD'),
                                           -1))
           AND H.PERIOD = EXTRACT(MONTH FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                     '&PERIOD' || '/1',
                                                     'YYYY/MM/DD'),
                                             -1))
           AND H1.YEAR = '&YEAR_I'
           AND H1.PERIOD = '&PERIOD'
           AND H.ACT_OUT_BAL > 0
           AND H1.STATE = 'Closed'
           AND (H1.LAST_VARIATION != 'CashConverted' OR H1.LAST_VARIATION IS NULL)
        
        UNION ALL
        
        SELECT H1.YEAR, --Cash Converted Closed Accounts
               H1.PERIOD,
               H.YEAR                     YEAR_P,
               H.PERIOD                   PERIOD_P,
               H1.ORIGINAL_ACCT_NO,
               H1.ACCT_NO,
               H1.SALES_DATE,
               H.ACT_OUT_BAL,
               H1.STATE,
               H1.LAST_VARIATION,
               H1.CASH_CONVERSION_ON_DATE
          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H,
               IFSAPP.HPNRET_FORM249_ARREARS_TAB H1
         WHERE H.ORIGINAL_ACCT_NO = H1.ORIGINAL_ACCT_NO
           AND H.ACCT_NO = H.ACCT_NO
           AND H.YEAR = EXTRACT(YEAR FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                   '&PERIOD' || '/1',
                                                   'YYYY/MM/DD'),
                                           -1))
           AND H.PERIOD = EXTRACT(MONTH FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                     '&PERIOD' || '/1',
                                                     'YYYY/MM/DD'),
                                             -1))
           AND H1.YEAR = '&YEAR_I'
           AND H1.PERIOD = '&PERIOD'
           AND H.ACT_OUT_BAL > 0
           AND H1.STATE = 'Closed'
           AND H1.LAST_VARIATION = 'CashConverted'
        
        UNION ALL
        
        SELECT H1.YEAR, --Full Term Active Accounts
               H1.PERIOD,
               H.YEAR                     YEAR_P,
               H.PERIOD                   PERIOD_P,
               H1.ORIGINAL_ACCT_NO,
               H1.ACCT_NO,
               H1.SALES_DATE,
               H.ACT_OUT_BAL,
               H1.STATE,
               H1.LAST_VARIATION,
               H1.CASH_CONVERSION_ON_DATE
          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H,
               IFSAPP.HPNRET_FORM249_ARREARS_TAB H1
         WHERE H.ORIGINAL_ACCT_NO = H1.ORIGINAL_ACCT_NO
           AND H.ACCT_NO = H.ACCT_NO
           AND H.YEAR = EXTRACT(YEAR FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                   '&PERIOD' || '/1',
                                                   'YYYY/MM/DD'),
                                           -1))
           AND H.PERIOD = EXTRACT(MONTH FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                     '&PERIOD' || '/1',
                                                     'YYYY/MM/DD'),
                                             -1))
           AND H1.YEAR = '&YEAR_I'
           AND H1.PERIOD = '&PERIOD'
           AND H1.STATE = 'Active'
           AND H1.CASH_CONVERSION_ON_DATE <=
               TO_DATE('&CUT_OFF_DATE', 'YYYY/MM/DD')
           AND H.ACT_OUT_BAL > 0
        
        UNION ALL
        
        SELECT H1.YEAR, --Eligible for Cash Conversion Old
               H1.PERIOD,
               H.YEAR                     YEAR_P,
               H.PERIOD                   PERIOD_P,
               H1.ORIGINAL_ACCT_NO,
               H1.ACCT_NO,
               H1.SALES_DATE,
               H.ACT_OUT_BAL,
               H1.STATE,
               H1.LAST_VARIATION,
               H1.CASH_CONVERSION_ON_DATE
          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H,
               IFSAPP.HPNRET_FORM249_ARREARS_TAB H1
         WHERE H.ORIGINAL_ACCT_NO = H1.ORIGINAL_ACCT_NO
           AND H.ACCT_NO = H.ACCT_NO
           AND H.YEAR = EXTRACT(YEAR FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                   '&PERIOD' || '/1',
                                                   'YYYY/MM/DD'),
                                           -1))
           AND H.PERIOD = EXTRACT(MONTH FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                     '&PERIOD' || '/1',
                                                     'YYYY/MM/DD'),
                                             -1))
           AND H1.YEAR = '&YEAR_I'
           AND H1.PERIOD = '&PERIOD'
           AND H.ACT_OUT_BAL > 0
           AND H1.STATE = 'Active'
           AND H1.CASH_CONVERSION_ON_DATE >
               TO_DATE('&CUT_OFF_DATE', 'YYYY/MM/DD')
        
        UNION ALL
        
        SELECT H1.YEAR, ----Eligible for Cash Conversion New
               H1.PERIOD,
               0                          "YEAR_P",
               0                          "PERIOD_P",
               H1.ORIGINAL_ACCT_NO,
               H1.ACCT_NO,
               H1.SALES_DATE,
               0                          ACT_OUT_BAL,
               H1.STATE,
               H1.LAST_VARIATION,
               H1.CASH_CONVERSION_ON_DATE
          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H1
         WHERE H1.YEAR = '&YEAR_I'
           AND H1.PERIOD = '&PERIOD'
           AND H1.STATE = 'Active'
           AND H1.CASH_CONVERSION_ON_DATE >
               TO_DATE('&CUT_OFF_DATE', 'YYYY/MM/DD')
           AND H1.SALES_DATE >= TO_DATE('&SALES_DATE', 'YYYY/MM/DD')) A
