/* Formatted on 4/11/2023 9:36:57 AM (QP5 v5.381) */
--Shopwise Cost of Sales

  SELECT csl.YEAR,
         csl.PERIOD,
         csl.SITE,
         ROUND (SUM (cost_of_sales), 2)     cost_of_sales
    FROM (SELECT ns.YEAR,                    --Current Month INV Cost of Sales
                 ns.PERIOD,
                 ns.SITE,
                 ns.PRODUCT_CODE,
                 ns.SALES_QUANTITY,
                 b.cost,
                 (ns.SALES_QUANTITY * b.cost)     cost_of_sales
            FROM (  SELECT EXTRACT (YEAR FROM i.invoice_date)     "YEAR",
                           EXTRACT (MONTH FROM i.invoice_date)    PERIOD,
                           t.c10                                  "SITE",
                           t.c5                                   PRODUCT_CODE,
                           SUM (
                               CASE
                                   WHEN t.net_curr_amount != 0
                                   THEN
                                         t.n2
                                       * (  t.net_curr_amount
                                          / ABS (t.net_curr_amount))
                                   ELSE
                                       IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                           t.invoice_id,
                                           t.item_id,
                                           T.N2)
                               END)                               SALES_QUANTITY
                      FROM ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                     WHERE     t.invoice_id = i.invoice_id
                           AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                           AND t.rowstate = 'Posted'
                           AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                               'INV'                       --in ('INV', 'PKG')
                           AND i.invoice_date BETWEEN TO_DATE ('&from_date',
                                                               'yyyy/mm/dd')
                                                  AND TO_DATE ('&to_date',
                                                               'yyyy/mm/dd')
                  GROUP BY EXTRACT (YEAR FROM i.invoice_date),
                           EXTRACT (MONTH FROM i.invoice_date),
                           t.c10,
                           t.c5) ns
                 INNER JOIN IFSAPP.INVENT_ONLINE_COST_TAB b
                     ON     ns.YEAR = b.year
                        AND ns.PERIOD = b.period
                        AND ns.SITE = b.contract
                        AND ns.PRODUCT_CODE = b.part_no
          UNION ALL
          --Previous Month INV Cost of Sales
          SELECT ns1.YEAR,
                 ns1.PERIOD,
                 ns1.SITE,
                 ns1.PRODUCT_CODE,
                 ns1.SALES_QUANTITY,
                 b.cost,
                 (ns1.SALES_QUANTITY * b.cost)     cost_of_sales
            FROM (  SELECT EXTRACT (YEAR FROM i.invoice_date)     "YEAR",
                           EXTRACT (MONTH FROM i.invoice_date)    PERIOD,
                           t.c10                                  "SITE",
                           t.c5                                   PRODUCT_CODE,
                           SUM (
                               CASE
                                   WHEN t.net_curr_amount != 0
                                   THEN
                                         t.n2
                                       * (  t.net_curr_amount
                                          / ABS (t.net_curr_amount))
                                   ELSE
                                       IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                           t.invoice_id,
                                           t.item_id,
                                           T.N2)
                               END)                               SALES_QUANTITY
                      FROM ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                     WHERE     t.invoice_id = i.invoice_id
                           AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                           AND t.rowstate = 'Posted'
                           AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                               'INV'                       --in ('INV', 'PKG')
                           AND i.invoice_date BETWEEN ADD_MONTHS (
                                                          TO_DATE ('&from_date',
                                                                   'yyyy/mm/dd'),
                                                          -1)
                                                  AND ADD_MONTHS (
                                                          TO_DATE ('&to_date',
                                                                   'yyyy/mm/dd'),
                                                          -1)
                  GROUP BY EXTRACT (YEAR FROM i.invoice_date),
                           EXTRACT (MONTH FROM i.invoice_date),
                           t.c10,
                           t.c5) ns1
                 INNER JOIN IFSAPP.INVENT_ONLINE_COST_TAB b
                     ON     ns1.YEAR = b.year
                        AND ns1.PERIOD = b.period
                        AND ns1.SITE = b.contract
                        AND ns1.PRODUCT_CODE = b.part_no
          UNION ALL
          --2nd Previous Month INV Cost of Sales
          SELECT ns2.YEAR,
                 ns2.PERIOD,
                 ns2.SITE,
                 ns2.PRODUCT_CODE,
                 ns2.SALES_QUANTITY,
                 b.cost,
                 (ns2.SALES_QUANTITY * b.cost)     cost_of_sales
            FROM (  SELECT EXTRACT (YEAR FROM i.invoice_date)     "YEAR",
                           EXTRACT (MONTH FROM i.invoice_date)    PERIOD,
                           t.c10                                  "SITE",
                           t.c5                                   PRODUCT_CODE,
                           SUM (
                               CASE
                                   WHEN t.net_curr_amount != 0
                                   THEN
                                         t.n2
                                       * (  t.net_curr_amount
                                          / ABS (t.net_curr_amount))
                                   ELSE
                                       IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                           t.invoice_id,
                                           t.item_id,
                                           T.N2)
                               END)                               SALES_QUANTITY
                      FROM ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                     WHERE     t.invoice_id = i.invoice_id
                           AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                           AND t.rowstate = 'Posted'
                           AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                               'INV'                       --in ('INV', 'PKG')
                           AND i.invoice_date BETWEEN ADD_MONTHS (
                                                          TO_DATE ('&from_date',
                                                                   'yyyy/mm/dd'),
                                                          -2)
                                                  AND ADD_MONTHS (
                                                          TO_DATE ('&to_date',
                                                                   'yyyy/mm/dd'),
                                                          -2)
                  GROUP BY EXTRACT (YEAR FROM i.invoice_date),
                           EXTRACT (MONTH FROM i.invoice_date),
                           t.c10,
                           t.c5) ns2
                 INNER JOIN IFSAPP.INVENT_ONLINE_COST_TAB b
                     ON     ns2.YEAR = b.year
                        AND ns2.PERIOD = b.period
                        AND ns2.SITE = b.contract
                        AND ns2.PRODUCT_CODE = b.part_no
          UNION ALL
          --3rd Previous Month INV Cost of Sales
          SELECT ns3.YEAR,
                 ns3.PERIOD,
                 ns3.SITE,
                 ns3.PRODUCT_CODE,
                 ns3.SALES_QUANTITY,
                 b.cost,
                 (ns3.SALES_QUANTITY * b.cost)     cost_of_sales
            FROM (  SELECT EXTRACT (YEAR FROM i.invoice_date)     "YEAR",
                           EXTRACT (MONTH FROM i.invoice_date)    PERIOD,
                           t.c10                                  "SITE",
                           t.c5                                   PRODUCT_CODE,
                           SUM (
                               CASE
                                   WHEN t.net_curr_amount != 0
                                   THEN
                                         t.n2
                                       * (  t.net_curr_amount
                                          / ABS (t.net_curr_amount))
                                   ELSE
                                       IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                           t.invoice_id,
                                           t.item_id,
                                           T.N2)
                               END)                               SALES_QUANTITY
                      FROM ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                     WHERE     t.invoice_id = i.invoice_id
                           AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                           AND t.rowstate = 'Posted'
                           AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                               'INV'                       --in ('INV', 'PKG')
                           AND i.invoice_date BETWEEN ADD_MONTHS (
                                                          TO_DATE ('&from_date',
                                                                   'yyyy/mm/dd'),
                                                          -3)
                                                  AND ADD_MONTHS (
                                                          TO_DATE ('&to_date',
                                                                   'yyyy/mm/dd'),
                                                          -3)
                  GROUP BY EXTRACT (YEAR FROM i.invoice_date),
                           EXTRACT (MONTH FROM i.invoice_date),
                           t.c10,
                           t.c5) ns3
                 INNER JOIN IFSAPP.INVENT_ONLINE_COST_TAB b
                     ON     ns3.YEAR = b.year
                        AND ns3.PERIOD = b.period
                        AND ns3.SITE = b.contract
                        AND ns3.PRODUCT_CODE = b.part_no
          UNION ALL
          --PKG Cost of Sales
          SELECT ps.YEAR,                    --Current Month PKG Cost of Sales
                 ps.PERIOD,
                 ps.SITE,
                 ps.catalog_no                    PRODUCT_CODE,
                 ps.SALES_QUANTITY,
                 b.cost,
                 (ps.SALES_QUANTITY * b.cost)     cost_of_sales
            FROM (  SELECT EXTRACT (YEAR FROM i.invoice_date)     "YEAR",
                           EXTRACT (MONTH FROM i.invoice_date)    PERIOD,
                           t.c10                                  "SITE",
                           p.catalog_no,
                           SUM (
                                 (CASE
                                      WHEN t.net_curr_amount != 0
                                      THEN
                                            t.n2
                                          * (  t.net_curr_amount
                                             / ABS (t.net_curr_amount))
                                      ELSE
                                          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                              t.invoice_id,
                                              t.item_id,
                                              T.N2)
                                  END)
                               * p.qty_per_assembly)              SALES_QUANTITY
                      FROM ifsapp.invoice_item_tab t
                           INNER JOIN ifsapp.INVOICE_TAB i
                               ON t.invoice_id = i.invoice_id
                           INNER JOIN ifsapp.sales_part_package_tab p
                               ON t.c10 = p.contract AND t.c5 = p.parent_part
                     WHERE     t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                           AND t.rowstate = 'Posted'
                           AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                               'PKG'
                           AND i.invoice_date BETWEEN TO_DATE ('&from_date',
                                                               'yyyy/mm/dd')
                                                  AND TO_DATE ('&to_date',
                                                               'yyyy/mm/dd')
                  GROUP BY EXTRACT (YEAR FROM i.invoice_date),
                           EXTRACT (MONTH FROM i.invoice_date),
                           t.c10,
                           p.catalog_no) ps
                 INNER JOIN IFSAPP.INVENT_ONLINE_COST_TAB b
                     ON     ps.YEAR = b.year
                        AND ps.PERIOD = b.period
                        AND ps.SITE = b.contract
                        AND ps.catalog_no = b.part_no
          UNION ALL
          --Previous Month PKG Cost of Sales
          SELECT ps1.YEAR,
                 ps1.PERIOD,
                 ps1.SITE,
                 ps1.catalog_no                    PRODUCT_CODE,
                 ps1.SALES_QUANTITY,
                 b.cost,
                 (ps1.SALES_QUANTITY * b.cost)     cost_of_sales
            FROM (  SELECT EXTRACT (YEAR FROM i.invoice_date)     "YEAR",
                           EXTRACT (MONTH FROM i.invoice_date)    PERIOD,
                           t.c10                                  "SITE",
                           p.catalog_no,
                           SUM (
                                 (CASE
                                      WHEN t.net_curr_amount != 0
                                      THEN
                                            t.n2
                                          * (  t.net_curr_amount
                                             / ABS (t.net_curr_amount))
                                      ELSE
                                          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                              t.invoice_id,
                                              t.item_id,
                                              T.N2)
                                  END)
                               * p.qty_per_assembly)              SALES_QUANTITY
                      FROM ifsapp.invoice_item_tab t
                           INNER JOIN ifsapp.INVOICE_TAB i
                               ON t.invoice_id = i.invoice_id
                           INNER JOIN ifsapp.sales_part_package_tab p
                               ON t.c10 = p.contract AND t.c5 = p.parent_part
                     WHERE     t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                           AND t.rowstate = 'Posted'
                           AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                               'PKG'
                           AND i.invoice_date BETWEEN ADD_MONTHS (
                                                          TO_DATE ('&from_date',
                                                                   'yyyy/mm/dd'),
                                                          -1)
                                                  AND ADD_MONTHS (
                                                          TO_DATE ('&to_date',
                                                                   'yyyy/mm/dd'),
                                                          -1)
                  GROUP BY EXTRACT (YEAR FROM i.invoice_date),
                           EXTRACT (MONTH FROM i.invoice_date),
                           t.c10,
                           p.catalog_no) ps1
                 INNER JOIN IFSAPP.INVENT_ONLINE_COST_TAB b
                     ON     ps1.YEAR = b.year
                        AND ps1.PERIOD = b.period
                        AND ps1.SITE = b.contract
                        AND ps1.catalog_no = b.part_no
          UNION ALL
          --2nd Previous Month PKG Cost of Sales
          SELECT ps2.YEAR,
                 ps2.PERIOD,
                 ps2.SITE,
                 ps2.catalog_no                    PRODUCT_CODE,
                 ps2.SALES_QUANTITY,
                 b.cost,
                 (ps2.SALES_QUANTITY * b.cost)     cost_of_sales
            FROM (  SELECT EXTRACT (YEAR FROM i.invoice_date)     "YEAR",
                           EXTRACT (MONTH FROM i.invoice_date)    PERIOD,
                           t.c10                                  "SITE",
                           p.catalog_no,
                           SUM (
                                 (CASE
                                      WHEN t.net_curr_amount != 0
                                      THEN
                                            t.n2
                                          * (  t.net_curr_amount
                                             / ABS (t.net_curr_amount))
                                      ELSE
                                          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                              t.invoice_id,
                                              t.item_id,
                                              T.N2)
                                  END)
                               * p.qty_per_assembly)              SALES_QUANTITY
                      FROM ifsapp.invoice_item_tab t
                           INNER JOIN ifsapp.INVOICE_TAB i
                               ON t.invoice_id = i.invoice_id
                           INNER JOIN ifsapp.sales_part_package_tab p
                               ON t.c10 = p.contract AND t.c5 = p.parent_part
                     WHERE     t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                           AND t.rowstate = 'Posted'
                           AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                               'PKG'
                           AND i.invoice_date BETWEEN ADD_MONTHS (
                                                          TO_DATE ('&from_date',
                                                                   'yyyy/mm/dd'),
                                                          -2)
                                                  AND ADD_MONTHS (
                                                          TO_DATE ('&to_date',
                                                                   'yyyy/mm/dd'),
                                                          -2)
                  GROUP BY EXTRACT (YEAR FROM i.invoice_date),
                           EXTRACT (MONTH FROM i.invoice_date),
                           t.c10,
                           p.catalog_no) ps2
                 INNER JOIN IFSAPP.INVENT_ONLINE_COST_TAB b
                     ON     ps2.YEAR = b.year
                        AND ps2.PERIOD = b.period
                        AND ps2.SITE = b.contract
                        AND ps2.catalog_no = b.part_no
          UNION ALL
          --3rd Previous Month PKG Cost of Sales
          SELECT ps3.YEAR,
                 ps3.PERIOD,
                 ps3.SITE,
                 ps3.catalog_no                    PRODUCT_CODE,
                 ps3.SALES_QUANTITY,
                 b.cost,
                 (ps3.SALES_QUANTITY * b.cost)     cost_of_sales
            FROM (  SELECT EXTRACT (YEAR FROM i.invoice_date)     "YEAR",
                           EXTRACT (MONTH FROM i.invoice_date)    PERIOD,
                           t.c10                                  "SITE",
                           p.catalog_no,
                           SUM (
                                 (CASE
                                      WHEN t.net_curr_amount != 0
                                      THEN
                                            t.n2
                                          * (  t.net_curr_amount
                                             / ABS (t.net_curr_amount))
                                      ELSE
                                          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (
                                              t.invoice_id,
                                              t.item_id,
                                              T.N2)
                                  END)
                               * p.qty_per_assembly)              SALES_QUANTITY
                      FROM ifsapp.invoice_item_tab t
                           INNER JOIN ifsapp.INVOICE_TAB i
                               ON t.invoice_id = i.invoice_id
                           INNER JOIN ifsapp.sales_part_package_tab p
                               ON t.c10 = p.contract AND t.c5 = p.parent_part
                     WHERE     t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                           AND t.rowstate = 'Posted'
                           AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) =
                               'PKG'
                           AND i.invoice_date BETWEEN ADD_MONTHS (
                                                          TO_DATE ('&from_date',
                                                                   'yyyy/mm/dd'),
                                                          -2)
                                                  AND ADD_MONTHS (
                                                          TO_DATE ('&to_date',
                                                                   'yyyy/mm/dd'),
                                                          -2)
                  GROUP BY EXTRACT (YEAR FROM i.invoice_date),
                           EXTRACT (MONTH FROM i.invoice_date),
                           t.c10,
                           p.catalog_no) ps3
                 INNER JOIN IFSAPP.INVENT_ONLINE_COST_TAB b
                     ON     ps3.YEAR = b.year
                        AND ps3.PERIOD = b.period
                        AND ps3.SITE = b.contract
                        AND ps3.catalog_no = b.part_no) csl
   WHERE csl.SITE NOT IN ('BSCP',                             --Service Center
                          'BLSP',
                          'CLSP',
                          'CSCP',
                          'DSCP',
                          'JSCP',
                          'MSCP',                         --New Service Center
                          'RSCP',
                          'SSCP',
                          'MS1C',
                          'MS2C',
                          'BTSC',
                          'APWH',                                  --Warehouse
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
                          'ABWW',                        --Wholesale Warehouse
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
                          'TUWW',                             --All Warehouses
                          'SACF',
                          'SAVF',
                          'SFRF',
                          'SCAF',                            /*Cable Factory*/
                                                                --Factory Site
                          'JWSS',
                          'SAOS',
                          'SWSS',
                          'WSMO',                            --Wholesale Sites
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
                          'CITF') --Corporate, Employee, & Scrap Sites, Trade Fair
GROUP BY csl.YEAR, csl.PERIOD, csl.SITE
ORDER BY csl.YEAR, csl.PERIOD, csl.SITE