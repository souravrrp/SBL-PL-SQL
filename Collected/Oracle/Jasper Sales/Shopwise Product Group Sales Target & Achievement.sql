--*****Shopwise Product Group Sales Target & Achievement
SELECT LL.AREA_CODE,
       LL.DISTRICT_CODE,
       LL.SHOP_CODE,
       LL.PRODUCT_GROUP,
       LL.TARGET_QTY,
       LL.ACHIEV_QTY,
       ROUND(CASE
               WHEN LL.TARGET_QTY = 0 THEN
                0
               ELSE
                (LL.ACHIEV_QTY / LL.TARGET_QTY) * 100
             END,
             2) QTN_ACHIEV_PRCNTG,
       LL.TARGET_AMOUNT,
       LL.ACHIEV_AMOUNT,
       ROUND(CASE
               WHEN LL.TARGET_AMOUNT = 0 THEN
                0
               ELSE
                (LL.ACHIEV_AMOUNT / LL.TARGET_AMOUNT) * 100
             END,
             2) AMT_ACHIEV_PRCNTG
  FROM (SELECT FF.AREA_CODE,
               FF.DISTRICT_CODE,
               FF.SHOP_CODE,
               FF.PRODUCT_GROUP,
               FF.TARGET_QTY,
               FF.TARGET_AMOUNT,
               CASE
                 WHEN NN.ACHIEV_QTY IS NULL THEN
                  0
                 ELSE
                  NN.ACHIEV_QTY
               END ACHIEV_QTY,
               NVL(NN.ACHIEV_AMOUNT, 0) ACHIEV_AMOUNT
          FROM (SELECT SDI.AREA_CODE,
                       TO_NUMBER(SDI.DISTRICT_CODE, 99) DISTRICT_CODE,
                       TT.SHOP_CODE,
                       PP.SERIAL_NO,
                       PP.PRODUCT_GROUP_CODE,
                       PP.PRODUCT_GROUP,
                       SUM(TT.QTY) TARGET_QTY,
                       (SUM(TT.QTY * PP.AVERAGE_VALUE)) TARGET_AMOUNT
                  FROM IFSAPP.SBL_JR_RST_PG_QTN_TGT    TT,
                       IFSAPP.SBL_JR_RST_PRODUCT_GROUP PP,
                       IFSAPP.SHOP_DTS_INFO            SDI
                 WHERE TT.YEAR = /*$P{YEAR_I}*/
                       '&YEAR_I'
                   AND TT.SHOP_CODE = SDI.SHOP_CODE
                   AND TT.PERIOD BETWEEN '&START_PERIOD' /*$P{START_PERIOD}*/
                       AND '&END_PERIOD' /*$P{END_PERIOD}*/
                   AND PP.PRODUCT_GROUP_CODE = TT.PRODUCT_GROUP_CODE
                   AND PP.YEAR = '&YEAR_I'
                 GROUP BY SDI.AREA_CODE,
                          SDI.DISTRICT_CODE,
                          TT.SHOP_CODE,
                          PP.SERIAL_NO,
                          PP.PRODUCT_GROUP_CODE,
                          PP.PRODUCT_GROUP
                 ORDER BY SDI.AREA_CODE,
                          SDI.DISTRICT_CODE,
                          TT.SHOP_CODE,
                          PP.SERIAL_NO,
                          PP.PRODUCT_GROUP_CODE,
                          PP.PRODUCT_GROUP) FF
          LEFT JOIN (SELECT CC.SHOP_CODE,
                           PPM.PRODUCT_GROUP_CODE,
                           SUM(CC.SALES_QUANTITY) ACHIEV_QTY,
                           SUM(CC.SALES_PRICE) ACHIEV_AMOUNT
                      FROM IFSAPP.SBL_JR_SALES_INV_COMP_VIEW CC,
                           IFSAPP.SBL_JR_PRODUCT_DTL_INFO    DI,
                           IFSAPP.SBL_JR_RST_PG_PF_MAP       PPM
                     WHERE DI.PRODUCT_CODE = CC.PRODUCT_CODE
                       AND DI.PRODUCT_FAMILY_CODE = PPM.PRODUCT_FAMILY_CODE
                       AND PPM.YEAR = '&YEAR_I'
                       AND EXTRACT(YEAR FROM CC.SALES_DATE) = /*$P{YEAR_I}*/
                           '&YEAR_I'
                       AND EXTRACT(MONTH FROM CC.SALES_DATE) BETWEEN
                           '&START_PERIOD' /*$P{START_PERIOD}*/
                           AND '&END_PERIOD' /*$P{END_PERIOD}*/
                     GROUP BY CC.SHOP_CODE, PPM.PRODUCT_GROUP_CODE
                     ORDER BY CC.SHOP_CODE, PPM.PRODUCT_GROUP_CODE) NN
            ON FF.PRODUCT_GROUP_CODE = NN.PRODUCT_GROUP_CODE
           AND FF.SHOP_CODE = NN.SHOP_CODE
         ORDER BY FF.AREA_CODE, FF.DISTRICT_CODE, FF.SHOP_CODE, FF.SERIAL_NO) LL
 WHERE /*$X{IN, LL.PRODUCT_GROUP, TARGET_PRODUCT_GROUP}*/
 LL.PRODUCT_GROUP = /*'REFRIGERATOR'*/ /*'FURNITURE'*/ /*'SMALL APPLIANCE'*/ /*'COMPUTER'*/ 'WASHING MACHINE'
