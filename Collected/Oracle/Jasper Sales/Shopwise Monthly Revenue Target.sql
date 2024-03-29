--*****Shopwise Monthly Revenue Target
SELECT MM.AREA_CODE,
       MM.DISTRICT_CODE,
       KK.SHOP_CODE,
       KK.TARGET_REVENUE,
       NVL(MM.ACHIEVEMENT, 0) ACHIEVEMENT,
       CASE
         WHEN KK.TARGET_REVENUE < 0 THEN
          0
         ELSE
          (MM.ACHIEVEMENT / KK.TARGET_REVENUE) * 100
       END ACHIEV_PRCNTG
  FROM (SELECT AA.SHOP_CODE, SUM(AA.REVENUE) TARGET_REVENUE
          FROM IFSAPP.SBL_JR_RST_REVENUE_TGT AA
         WHERE AA.PERIOD BETWEEN '&START_PERIOD' /*$P{START_PERIOD}*/ AND '&END_PERIOD' /*$P{END_PERIOD}*/
           AND AA.YEAR = '&year'/*$P{YEAR_I}*/
         GROUP BY AA.SHOP_CODE
         ORDER BY AA.SHOP_CODE) KK
  LEFT JOIN (SELECT BB.AREA_CODE,
                    BB.DISTRICT_CODE,
                    BB.SHOP_CODE,
                    NVL(SUM(BB.SALES_PRICE), 0) ACHIEVEMENT
               FROM IFSAPP.SBL_JR_SALES_INV_PKG_VIEW BB
              WHERE EXTRACT(MONTH FROM BB.SALES_DATE) BETWEEN
                    '&START_PERIOD' /*$P{START_PERIOD}*/ AND '&END_PERIOD' /*$P{END_PERIOD}*/
                AND EXTRACT(YEAR FROM BB.SALES_DATE) = '&year' /*$P{YEAR_I}*/
              GROUP BY BB.AREA_CODE, BB.DISTRICT_CODE, BB.SHOP_CODE
              ORDER BY BB.AREA_CODE, BB.DISTRICT_CODE, BB.SHOP_CODE) MM
    ON KK.SHOP_CODE = MM.SHOP_CODE
 WHERE /*$X{IN, MM.AREA_CODE, AREA_CODE}*/ MM.AREA_CODE like 'Central%'
 ORDER BY TO_NUMBER(MM.DISTRICT_CODE, 99), KK.SHOP_CODE /*MM.AREA_CODE*/
