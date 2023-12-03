--***** Count not completed sites
select CASE
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
       U.SITE,
       U.USER_ID,
       IFSAPP.Customer_Info_Api.Get_Name(U.USER_ID) USER_NAME,
       /*U.COUNT_YEAR,*/
       U.DATE_OF_COUNT /*,
U.PASS*/
  from IFSAPP.SBL_USER_LIST U
 where U.DATE_OF_COUNT <= TO_DATE('&COUNT_DATE', 'YYYY/MM/DD')
   AND U.USER_ID != 'E10206'
   AND NOT EXISTS (SELECT A.SHOP_CODE
          FROM IFSAPP.SBL_SHOP_ARRPOVE_TBL A
         WHERE A.SHOP_CODE = U.SITE
           AND A.APPROVE_STATUS = 1
        /*AND TRUNC(A.APPROVE_DATE) = TO_DATE('&COUNT_DATE', 'YYYY/MM/DD')*/
        )
 ORDER BY 1, 2
