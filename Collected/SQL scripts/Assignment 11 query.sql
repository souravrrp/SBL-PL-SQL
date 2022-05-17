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
       H.ACTUAL_UCC,
       last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1', 'YYYY/MM/DD')) Cutoff_Date,
       floor((last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                               'YYYY/MM/DD')) - H.Sales_Date) / 30) "AGE of the ACC",
       CASE
         WHEN (H.Loc >=
              (floor(last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                       'YYYY/MM/DD')) - H.Sales_Date) / 30)) THEN
          (H.Loc -
          floor((last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                   'YYYY/MM/DD')) - H.Sales_Date) / 30))
         ELSE
          (floor((last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                   'YYYY/MM/DD')) - H.Sales_Date) / 30) -
          H.Loc)
       END AS "Remaining Month for Accru",
       
       fn_pv(H.Effective_Rate,
             H.Monthly_Pay,
             (CASE
               WHEN (H.Loc >=
                    (floor(last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                             'YYYY/MM/DD')) - H.Sales_Date) / 30)) THEN
                (H.Loc -
                floor((last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                         'YYYY/MM/DD')) - H.Sales_Date) / 30))
               ELSE
                (floor((last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                         'YYYY/MM/DD')) - H.Sales_Date) / 30) -
                H.Loc)
             END)) as PV_Accrual,
       
       ROUND((CASE
               WHEN (H.Loc >=
                    (floor(last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                             'YYYY/MM/DD')) - H.Sales_Date) / 30)) THEN
                (H.Loc -
                floor((last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                         'YYYY/MM/DD')) - H.Sales_Date) / 30))
               ELSE
                (floor((last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                         'YYYY/MM/DD')) - H.Sales_Date) / 30) -
                H.Loc)
             END) * H.Monthly_Pay - (fn_pv(H.Effective_Rate,
                                           H.Monthly_Pay,
                                           (CASE
                                             WHEN (H.Loc >=
                                                  (floor(last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                                                           'YYYY/MM/DD')) - H.Sales_Date) / 30)) THEN
                                              (H.Loc -
                                              floor((last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                                                       'YYYY/MM/DD')) - H.Sales_Date) / 30))
                                             ELSE
                                              (floor((last_day(to_date(H.YEAR || '/' || H.PERIOD || '/1',
                                                                       'YYYY/MM/DD')) - H.Sales_Date) / 30) -
                                              H.Loc)
                                           END))),
             2) as "Remaining UCC As per accrual"

  FROM HPNRET_FORM249_ARREARS_TAB H
 WHERE H.YEAR = '&year_i'
   AND H.PERIOD = '&period_i'
   AND H.ACT_OUT_BAL > 0
   AND H.ARR_MON /*NOT*/
       IN (1, 2, 3)
--AND H.ACCT_NO != 'DBL-H2291' --'SES-H320'   
 ORDER BY H.ARR_MON
