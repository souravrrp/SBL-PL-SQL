-- Count Completion Status Summary Area-wise
SELECT C.DATE_OF_COUNT,
       C.AREA,
       COUNT(C.SITE) NO_OF_SHOP,
       COUNT(C.COUNTED_SHOP) NO_OF_COUNTED_SHOP
  FROM (SELECT U.*,
               CASE
                 WHEN U.SITE IN ('SACF', 'SAVF', 'SFRF') THEN
                  'Factory'
                 WHEN U.SITE IN ('BSCP',
                                 'BLSP',
                                 'CLSP',
                                 'CSCP',
                                 'CXSP',
                                 'DSCP',
                                 'FSCP', --New Service Center
                                 'JSCP',
                                 'KSCP',
                                 'MSCP',
                                 'NSCP',
                                 'RPSP',
                                 'RSCP',
                                 'SSCP',
                                 'MS1C',
                                 'MS2C',
                                 'BTSC') THEN
                  'Service Center'
                 WHEN U.SITE IN (SELECT W.WARE_HOUSE_NAME FROM WARE_HOUSE_INFO W) THEN
                  'Warehouse'
                 ELSE
                  (SELECT S.AREA_CODE
                     FROM IFSAPP.SHOP_DTS_INFO S
                    WHERE S.SHOP_CODE = U.SITE)
               END AREA,
               (SELECT A.SHOP_CODE
                  FROM IFSAPP.SBL_SHOP_ARRPOVE_TBL A
                 WHERE A.SHOP_CODE = U.SITE
                   AND A.APPROVE_STATUS = 1
                 GROUP BY A.SHOP_CODE) COUNTED_SHOP
          FROM IFSAPP.SBL_USER_LIST U) C
 WHERE C.DATE_OF_COUNT = TO_DATE('&COUNT_DATE', 'YYYY/MM/DD')
   AND C.USER_ID != 'E10206'
 GROUP BY C.DATE_OF_COUNT, C.AREA
 ORDER BY C.DATE_OF_COUNT, C.AREA
