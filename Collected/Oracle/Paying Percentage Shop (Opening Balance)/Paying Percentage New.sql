--******Paying Percentage by new formula
SELECT OB.YEAR,
       OB.PERIOD,
       OB.SHOP_CODE,
       (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = OB.SHOP_CODE) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = OB.SHOP_CODE) district_code,
       NVL(OB.Active_Account, 0) Active_Account,
       /*NVL(AA.ARR_ACT, 0) ARR_ACT,
       NVL(ABP.ARR_BUT_PAYING, 0) ARR_BUT_PAYING,
       NVL(RVA.REV_ACT, 0) REV_ACT,
       NVL(WO.WRITE_OFF_ACT, 0) WRITE_OFF_ACT,*/
       (NVL(OB.Active_Account, 0) - NVL(AA.ARR_ACT, 0) +
       NVL(ABP.ARR_BUT_PAYING, 0) - NVL(RVA.REV_ACT, 0) -
       NVL(WO.WRITE_OFF_ACT, 0)) PAYING_ACCOUNTS,
       ROUND((((NVL(OB.Active_Account, 0) - NVL(AA.ARR_ACT, 0) +
             NVL(ABP.ARR_BUT_PAYING, 0) - NVL(RVA.REV_ACT, 0) -
             NVL(WO.WRITE_OFF_ACT, 0)) / NVL(OB.Active_Account, 0)) * 100),
             2) PAYING_PERCENTAGE
  FROM (SELECT '&YEAR' "YEAR", --Opening Balance for the month
               '&MONTH' PERIOD,
               h.SHOP_CODE,
               COUNT(*) Active_Account
          from IFSAPP.hpnret_form249_arrears_tab h
         where H.YEAR = EXTRACT(YEAR FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                             'YYYY/MM/DD') - 1))
           AND H.PERIOD =
               EXTRACT(MONTH FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                    'YYYY/MM/DD') - 1))
           AND H.ACT_OUT_BAL > 0
         GROUP BY h.YEAR, h.PERIOD, H.SHOP_CODE) OB
  LEFT JOIN (SELECT CLB.YEAR, --No of Arrear Accounts
                    CLB.PERIOD,
                    OPB.SHOP_CODE,
                    NVL(COUNT(*), 0) ARR_ACT
               FROM (SELECT HP.YEAR, --Opening Balance for the month
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
                      where HP.YEAR =
                            EXTRACT(YEAR
                                    FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                                 'YYYY/MM/DD') - 1))
                        AND HP.PERIOD =
                            EXTRACT(MONTH
                                    FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                                 'YYYY/MM/DD') - 1))
                        AND HP.ACT_OUT_BAL > 0) OPB
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
              WHERE CLB.ARR_AMT > 0
              GROUP BY CLB.YEAR, CLB.PERIOD, OPB.SHOP_CODE) AA
    ON OB.YEAR = AA.YEAR
   AND OB.PERIOD = AA.PERIOD
   AND OB.SHOP_CODE = AA.SHOP_CODE
  LEFT JOIN (SELECT CLB.YEAR, --No of Arrear but Paying Accounts
                    CLB.PERIOD,
                    OPB.SHOP_CODE,
                    NVL(COUNT(*), 0) ARR_BUT_PAYING
               FROM (SELECT HP.YEAR, --Opening Balance for the month
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
                      where HP.YEAR =
                            EXTRACT(YEAR
                                    FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                                 'YYYY/MM/DD') - 1))
                        AND HP.PERIOD =
                            EXTRACT(MONTH
                                    FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                                 'YYYY/MM/DD') - 1))
                        AND HP.ACT_OUT_BAL > 0) OPB
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
              WHERE CLB.ACT_OUT_BAL > 0
                AND CLB.ARR_AMT > 0
                AND CLB.COLLECTION >= CLB.MONTHLY_PAY
              GROUP BY CLB.YEAR, CLB.PERIOD, OPB.SHOP_CODE) ABP
    ON OB.YEAR = ABP.YEAR
   AND OB.PERIOD = ABP.PERIOD
   AND OB.SHOP_CODE = ABP.SHOP_CODE
  LEFT JOIN (SELECT CLB.YEAR, --No of Revert Accounts
                    CLB.PERIOD,
                    OPB.SHOP_CODE,
                    NVL(COUNT(*), 0) REV_ACT
               FROM (SELECT HP.YEAR, --Opening Balance for the month
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
                      where HP.YEAR =
                            EXTRACT(YEAR
                                    FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                                 'YYYY/MM/DD') - 1))
                        AND HP.PERIOD =
                            EXTRACT(MONTH
                                    FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                                 'YYYY/MM/DD') - 1))
                        AND HP.ACT_OUT_BAL > 0) OPB
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
              WHERE CLB.ACT_OUT_BAL = 0
                AND CLB.LAST_VARIATION = 'Reverted'
              GROUP BY CLB.YEAR, CLB.PERIOD, OPB.SHOP_CODE) RVA
    ON OB.YEAR = RVA.YEAR
   AND OB.PERIOD = RVA.PERIOD
   AND OB.SHOP_CODE = RVA.SHOP_CODE
  LEFT JOIN (SELECT CLB.YEAR, --No of Write Off Accounts
                    CLB.PERIOD,
                    OPB.SHOP_CODE,
                    NVL(COUNT(*), 0) WRITE_OFF_ACT
               FROM (SELECT HP.YEAR, --Opening Balance for the month
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
                      where HP.YEAR =
                            EXTRACT(YEAR
                                    FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                                 'YYYY/MM/DD') - 1))
                        AND HP.PERIOD =
                            EXTRACT(MONTH
                                    FROM(TO_DATE('&YEAR' || '/' || '&MONTH' || '/1',
                                                 'YYYY/MM/DD') - 1))
                        AND HP.ACT_OUT_BAL > 0) OPB
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
              INNER JOIN (select AU.account_no, --Write Off List from HP Authorization
                                AU.variation_db "Variation_ID",
                                ifsapp.Variation_API.Decode(AU.variation_db) Variation_Name,
                                AU.from_date Permission_Date,
                                AU.utilized "Service_Utilized",
                                AU.discount "Discount",
                                AU.discount_percentage "Discount_Percent",
                                AU.service_charge "Service_Charge"
                           from IFSAPP.HPNRET_AUTH_VARIATION AU
                          where AU.utilized = 1
                            and AU.variation_db = 1) A
                 ON CLB.ACCT_NO = A.account_no
              WHERE CLB.ACT_OUT_BAL = 0
                AND CLB.LAST_VARIATION = 'DiscountClosed'
              GROUP BY CLB.YEAR, CLB.PERIOD, OPB.SHOP_CODE) WO
    ON OB.YEAR = WO.YEAR
   AND OB.PERIOD = WO.PERIOD
   AND OB.SHOP_CODE = WO.SHOP_CODE
 WHERE OB.SHOP_CODE NOT IN ('BSCP',
                            'BLSP',
                            'CSCP',
                            'CLSP',
                            'DSCP',
                            'JSCP',
                            'MSCP',
                            'RSCP',
                            'SSCP',
                            'MS1C',
                            'MS2C',
                            'BTSC') --Service Sites
   AND OB.SHOP_CODE NOT IN ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
   AND OB.SHOP_CODE NOT IN ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SCOM') --Corporate, Employee, & Scrap Sites
 ORDER BY 4, 5, 3
