-- Gelmart Report 2 Specialized Version
SELECT E.YEAR,
       E.PERIOD,
       E.ACCT_NO,
       E.CUSTOMER,
       E.CUSTOMER_NAME,
       E.ARR_MON,
       CASE
         WHEN CEIL(E.ARR_AMT_SELECTED / E.MONTHLY_PAY) > 12 THEN
          '12+'
         ELSE
          TO_CHAR(CEIL(E.ARR_AMT_SELECTED / E.MONTHLY_PAY))
       END NO_OF_MON_IN_ARR,
       E.DEL_MON,
       E.ACT_OUT_BAL,
       E.PRESENT_VALUE
  FROM (SELECT D.*,
               CASE
                 WHEN D.COLLECTION != 0 THEN
                  D.ARR_AMT
                 WHEN D.COLLECTION_MAR != 0 THEN
                  D.ARR_AMT_MAR
                 ELSE
                  D.ARR_AMT_FEB
               END ARR_AMT_SELECTED
          FROM (SELECT A.YEAR,
                       A.PERIOD,
                       A.ACCT_NO,
                       A.CUSTOMER,
                       IFSAPP.CUSTOMER_INFO_API.Get_Name(A.CUSTOMER) CUSTOMER_NAME,
                       A.MONTHLY_PAY,
                       A.COLLECTION,
                       NVL(B.COLLECTION, 0) COLLECTION_MAR,
                       NVL(C.COLLECTION, 0) COLLECTION_FEB,
                       A.ARR_AMT,
                       NVL(B.ARR_AMT, 0) ARR_AMT_MAR,
                       NVL(C.ARR_AMT, 0) ARR_AMT_FEB,
                       case
                         when A.ARR_MON > 12 then
                          '12+'
                         else
                          to_char(A.ARR_MON)
                       end ARR_MON,
                       case
                         when A.DEL_MON > 12 then
                          '12+'
                         else
                          to_char(A.DEL_MON)
                       end DEL_MON,
                       A.ACT_OUT_BAL,
                       A.PRESENT_VALUE
                  FROM (SELECT H.*
                          FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H
                         WHERE H.YEAR = '&YEAR_I'
                           AND H.PERIOD = '&PERIOD'
                           AND H.ACT_OUT_BAL > 0
                           AND H.MONTHLY_PAY <> 0) A
                
                  LEFT JOIN (SELECT H1.*
                              FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H1
                             WHERE H1.YEAR =
                                   EXTRACT(YEAR FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                              '&PERIOD' || '/1',
                                                              'YYYY/MM/DD'),
                                                      -1))
                               AND H1.PERIOD =
                                   EXTRACT(MONTH FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                              '&PERIOD' || '/1',
                                                              'YYYY/MM/DD'),
                                                      -1))
                               AND H1.ACT_OUT_BAL > 0) B
                    ON A.ACCT_NO = B.ACCT_NO
                
                  LEFT JOIN (SELECT H2.*
                              FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H2
                             WHERE H2.YEAR =
                                   EXTRACT(YEAR FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                              '&PERIOD' || '/1',
                                                              'YYYY/MM/DD'),
                                                      -2))
                               AND H2.PERIOD =
                                   EXTRACT(MONTH FROM ADD_MONTHS(TO_DATE('&YEAR_I' || '/' ||
                                                              '&PERIOD' || '/1',
                                                              'YYYY/MM/DD'),
                                                      -2))
                               AND H2.ACT_OUT_BAL > 0) C
                    ON A.ACCT_NO = C.ACCT_NO) D) E
