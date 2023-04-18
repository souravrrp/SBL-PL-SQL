/* Formatted on 4/10/2023 1:10:23 PM (QP5 v5.381) */
--Shopwise Inventory Value

  SELECT i.YEAR,
         i.PERIOD,
         i.site,
         (SELECT sh.area_code
            FROM SHOP_DTS_INFO sh
           WHERE sh.shop_code = i.site)    area_code,
         (SELECT sh.district_code
            FROM SHOP_DTS_INFO sh
           WHERE sh.shop_code = i.site)    district_code,
         ROUND (SUM (inv_value), 2)        inv_value
    FROM (SELECT b.year,                       --Current Month Inventory Value
                 b.period,
                 b.site,
                 b.location,
                 b.part_no,
                 b.product_family,
                 b.product_line,
                 b.closing_bal,
                 b.in_transit,
                 b.cost,
                 ((b.closing_bal + b.in_transit) * b.cost)     inv_value
            FROM IFSAPP.INVENTORY_BALANCE b
           WHERE b.year = '&year_i' AND b.period = '&period'
          UNION ALL
          --Previous Month Inventory Value
          SELECT b.year,
                 b.period,
                 b.site,
                 b.location,
                 b.part_no,
                 b.product_family,
                 b.product_line,
                 b.closing_bal,
                 b.in_transit,
                 b.cost,
                 ((b.closing_bal + b.in_transit) * b.cost)     inv_value
            FROM IFSAPP.INVENTORY_BALANCE b
           WHERE     b.year =
                     EXTRACT (
                         YEAR FROM ADD_MONTHS (
                                       TO_DATE (
                                              '&year_i'
                                           || '/'
                                           || '&period'
                                           || '/1',
                                           'YYYY/MM/DD'),
                                       -1))
                 AND b.period =
                     EXTRACT (
                         MONTH FROM ADD_MONTHS (
                                        TO_DATE (
                                               '&year_i'
                                            || '/'
                                            || '&period'
                                            || '/1',
                                            'YYYY/MM/DD'),
                                        -1))
          UNION ALL
          --2nd Previous Month Inventory Value
          SELECT b.year,
                 b.period,
                 b.site,
                 b.location,
                 b.part_no,
                 b.product_family,
                 b.product_line,
                 b.closing_bal,
                 b.in_transit,
                 b.cost,
                 ((b.closing_bal + b.in_transit) * b.cost)     inv_value
            FROM IFSAPP.INVENTORY_BALANCE b
           WHERE     b.year =
                     EXTRACT (
                         YEAR FROM ADD_MONTHS (
                                       TO_DATE (
                                              '&year_i'
                                           || '/'
                                           || '&period'
                                           || '/1',
                                           'YYYY/MM/DD'),
                                       -2))
                 AND b.period =
                     EXTRACT (
                         MONTH FROM ADD_MONTHS (
                                        TO_DATE (
                                               '&year_i'
                                            || '/'
                                            || '&period'
                                            || '/1',
                                            'YYYY/MM/DD'),
                                        -2))
          UNION ALL
          --3rd Previous Month Inventory Value
          SELECT b.year,
                 b.period,
                 b.site,
                 b.location,
                 b.part_no,
                 b.product_family,
                 b.product_line,
                 b.closing_bal,
                 b.in_transit,
                 b.cost,
                 ((b.closing_bal + b.in_transit) * b.cost)     inv_value
            FROM IFSAPP.INVENTORY_BALANCE b
           WHERE     b.year =
                     EXTRACT (
                         YEAR FROM ADD_MONTHS (
                                       TO_DATE (
                                              '&year_i'
                                           || '/'
                                           || '&period'
                                           || '/1',
                                           'YYYY/MM/DD'),
                                       -3))
                 AND b.period =
                     EXTRACT (
                         MONTH FROM ADD_MONTHS (
                                        TO_DATE (
                                               '&year_i'
                                            || '/'
                                            || '&period'
                                            || '/1',
                                            'YYYY/MM/DD'),
                                        -3))) i
   WHERE i.site NOT IN ('BSCP',                               --Service Center
                        'BLSP',
                        'CLSP',
                        'CSCP',
                        'DSCP',
                        'JSCP',
                        'MSCP',                           --New Service Center
                        'RSCP',
                        'SSCP',
                        'MS1C',
                        'MS2C',
                        'BTSC',
                        'APWH',                                    --Warehouse
                        'BBWH',
                        'BWHW',
                        'CMWH',
                        'CTGW',
                        'KWHW',
                        'MYWH',
                        'RWHW',
                        'SPWH',
                        'SWHW',
                        'SYWH',
                        'TWHW',
                        'ABWW',                          --Wholesale Warehouse
                        'BAWW',
                        'BGWW',
                        'CLWW',
                        'CTWW',
                        'KHWW',
                        'MHWW',
                        'RHWW',
                        'SDWW',
                        'SVWW',
                        'SLWW',
                        'TUWW',                               --All Warehouses
                        'SACF',
                        'SAVF',
                        'SFRF',
                        'SCAF',                              /*Cable Factory*/
                                                                --Factory Site
                        'JWSS',
                        'SAOS',
                        'SWSS',
                        'WSMO',                              --Wholesale Sites
                        'SAPM',
                        'SCSM',
                        'SESM',
                        'SHOM',
                        'SISM',
                        'SFSM',
                        'SOSM',
                        'DWWH',
                        'SCOM',
                        'DITF',
                        'CITF')           --Corporate, Employee, & Scrap Sites
GROUP BY i.YEAR, i.PERIOD, i.site
ORDER BY i.YEAR,
         i.PERIOD,
         5,
         i.site