SELECT H.YEAR,
       H.PERIOD,
       H.SHOP_CODE,
       H.ACCT_NO,
       H.CUSTOMER,
       H.MONTHLY_PAY,
       H.ACT_OUT_BAL,
       H.EFFECTIVE_RATE,
       H.PRESENT_VALUE,
       H.ACTUAL_UCC,
       CASE WHEN H.ACT_OUT_BAL >= H.MONTHLY_PAY 
              THEN H.MONTHLY_PAY
            ELSE H.ACT_OUT_BAL
       END MONTH_1,
       CASE WHEN H.ACT_OUT_BAL >= (2 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - H.MONTHLY_PAY > 0
              THEN H.ACT_OUT_BAL - H.MONTHLY_PAY
            ELSE 0
       END MONTH_2,
       CASE WHEN H.ACT_OUT_BAL >= (3 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (2 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (2 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_3,
       CASE WHEN H.ACT_OUT_BAL >= (4 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (3 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (3 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_4,
       CASE WHEN H.ACT_OUT_BAL >= (5 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (4 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (4 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_5,
       CASE WHEN H.ACT_OUT_BAL >= (6 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (5 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (5 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_6,
       CASE WHEN H.ACT_OUT_BAL >= (7 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (6 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (6 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_7,
       CASE WHEN H.ACT_OUT_BAL >= (8 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (7 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (7 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_8,
       CASE WHEN H.ACT_OUT_BAL >= (9 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (8 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (8 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_9,
       CASE WHEN H.ACT_OUT_BAL >= (10 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (9 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (9 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_10,
       CASE WHEN H.ACT_OUT_BAL >= (11 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (10 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (10 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_11,
       CASE WHEN H.ACT_OUT_BAL >= (12 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (11 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (11 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_12,
       CASE WHEN H.ACT_OUT_BAL >= (12 * H.MONTHLY_PAY)
              THEN H.ACT_OUT_BAL - (12 * H.MONTHLY_PAY)
            ELSE 0
       END MONTH_13
FROM   IFSAPP.HPNRET_FORM249_ARREARS_TAB H
WHERE  H.YEAR = '&YEAR_I' 
AND    H.PERIOD = '&PERIOD' 
AND    H.ACT_OUT_BAL > 0
