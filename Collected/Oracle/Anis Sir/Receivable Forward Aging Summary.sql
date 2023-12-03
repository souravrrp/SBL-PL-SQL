SELECT H.YEAR,
       H.PERIOD,
       /*H.SHOP_CODE,
       H.ACCT_NO,
       H.MONTHLY_PAY,
       H.ACT_OUT_BAL,
       H.EFFECTIVE_RATE,
       H.PRESENT_VALUE,
       H.ACTUAL_UCC,*/
       SUM(CASE WHEN H.ACT_OUT_BAL >= H.MONTHLY_PAY 
              THEN H.MONTHLY_PAY
            ELSE H.ACT_OUT_BAL
       END) TOTAL_MONTH_1,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (2 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - H.MONTHLY_PAY > 0
              THEN H.ACT_OUT_BAL - H.MONTHLY_PAY
            ELSE 0
       END) TOTAL_MONTH_2,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (3 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (2 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (2 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_3,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (4 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (3 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (3 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_4,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (5 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (4 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (4 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_5,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (6 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (5 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (5 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_6,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (7 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (6 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (6 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_7,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (8 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (7 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (7 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_8,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (9 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (8 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (8 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_9,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (10 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (9 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (9 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_10,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (11 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (10 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (10 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_11,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (12 * H.MONTHLY_PAY)
              THEN H.MONTHLY_PAY
            WHEN H.ACT_OUT_BAL - (11 * H.MONTHLY_PAY) > 0
              THEN H.ACT_OUT_BAL - (11 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_12,
       SUM(CASE WHEN H.ACT_OUT_BAL >= (12 * H.MONTHLY_PAY)
              THEN H.ACT_OUT_BAL - (12 * H.MONTHLY_PAY)
            ELSE 0
       END) TOTAL_MONTH_13
FROM   HPNRET_FORM249_ARREARS_TAB H
WHERE  H.YEAR = '&YEAR_I' 
AND    H.PERIOD = '&PERIOD' 
AND    H.ACT_OUT_BAL > 0
GROUP BY H.YEAR, H.PERIOD
