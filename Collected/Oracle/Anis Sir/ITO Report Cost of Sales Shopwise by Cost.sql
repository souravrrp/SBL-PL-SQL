--Shopwise Cost of Sales
select csl.YEAR,
       csl.PERIOD,
       csl.SITE,
       round(sum(cost_of_sales), 2) cost_of_sales
  from (select ns.YEAR, --Current Month INV Cost of Sales
               ns.PERIOD,
               ns.SITE,
               ns.PRODUCT_CODE,
               ns.SALES_QUANTITY,
               b.cost,
               (ns.SALES_QUANTITY * b.cost) cost_of_sales
          from (select extract(year from i.invoice_date) "YEAR",
                       extract(month from i.invoice_date) PERIOD,
                       t.c10 "SITE",
                       t.c5 PRODUCT_CODE,
                       sum(case
                             when t.net_curr_amount != 0 then
                              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                             else
                              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                                 t.item_id,
                                                                 T.N2)
                           end) SALES_QUANTITY
                  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                 where t.invoice_id = i.invoice_id
                   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   and t.rowstate = 'Posted'
                   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV' --in ('INV', 'PKG')
                   and i.invoice_date between
                       to_date('&from_date', 'yyyy/mm/dd') and
                       to_date('&to_date', 'yyyy/mm/dd')
                 group by extract(year from i.invoice_date),
                          extract(month from i.invoice_date),
                          t.c10,
                          t.c5) ns
         inner join IFSAPP.INVENT_ONLINE_COST_TAB b
            on ns.YEAR = b.year
           and ns.PERIOD = b.period
           and ns.SITE = b.contract
           and ns.PRODUCT_CODE = b.part_no
        
        union all
        
        --Previous Month INV Cost of Sales
        select ns1.YEAR,
               ns1.PERIOD,
               ns1.SITE,
               ns1.PRODUCT_CODE,
               ns1.SALES_QUANTITY,
               b.cost,
               (ns1.SALES_QUANTITY * b.cost) cost_of_sales
          from (select extract(year from i.invoice_date) "YEAR",
                       extract(month from i.invoice_date) PERIOD,
                       t.c10 "SITE",
                       t.c5 PRODUCT_CODE,
                       sum(case
                             when t.net_curr_amount != 0 then
                              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                             else
                              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                                 t.item_id,
                                                                 T.N2)
                           end) SALES_QUANTITY
                  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                 where t.invoice_id = i.invoice_id
                   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   and t.rowstate = 'Posted'
                   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV' --in ('INV', 'PKG')
                   and i.invoice_date between
                       add_months(to_date('&from_date', 'yyyy/mm/dd'), -1) and
                       add_months(to_date('&to_date', 'yyyy/mm/dd'), -1)
                 group by extract(year from i.invoice_date),
                          extract(month from i.invoice_date),
                          t.c10,
                          t.c5) ns1
         inner join IFSAPP.INVENT_ONLINE_COST_TAB b
            on ns1.YEAR = b.year
           and ns1.PERIOD = b.period
           and ns1.SITE = b.contract
           and ns1.PRODUCT_CODE = b.part_no
        
        union all
        
        --2nd Previous Month INV Cost of Sales
        select ns2.YEAR,
               ns2.PERIOD,
               ns2.SITE,
               ns2.PRODUCT_CODE,
               ns2.SALES_QUANTITY,
               b.cost,
               (ns2.SALES_QUANTITY * b.cost) cost_of_sales
          from (select extract(year from i.invoice_date) "YEAR",
                       extract(month from i.invoice_date) PERIOD,
                       t.c10 "SITE",
                       t.c5 PRODUCT_CODE,
                       sum(case
                             when t.net_curr_amount != 0 then
                              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                             else
                              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                                 t.item_id,
                                                                 T.N2)
                           end) SALES_QUANTITY
                  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                 where t.invoice_id = i.invoice_id
                   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   and t.rowstate = 'Posted'
                   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV' --in ('INV', 'PKG')
                   and i.invoice_date between
                       add_months(to_date('&from_date', 'yyyy/mm/dd'), -2) and
                       add_months(to_date('&to_date', 'yyyy/mm/dd'), -2)
                 group by extract(year from i.invoice_date),
                          extract(month from i.invoice_date),
                          t.c10,
                          t.c5) ns2
         inner join IFSAPP.INVENT_ONLINE_COST_TAB b
            on ns2.YEAR = b.year
           and ns2.PERIOD = b.period
           and ns2.SITE = b.contract
           and ns2.PRODUCT_CODE = b.part_no
        
        union all
        
        --3rd Previous Month INV Cost of Sales
        select ns3.YEAR,
               ns3.PERIOD,
               ns3.SITE,
               ns3.PRODUCT_CODE,
               ns3.SALES_QUANTITY,
               b.cost,
               (ns3.SALES_QUANTITY * b.cost) cost_of_sales
          from (select extract(year from i.invoice_date) "YEAR",
                       extract(month from i.invoice_date) PERIOD,
                       t.c10 "SITE",
                       t.c5 PRODUCT_CODE,
                       sum(case
                             when t.net_curr_amount != 0 then
                              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                             else
                              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                                 t.item_id,
                                                                 T.N2)
                           end) SALES_QUANTITY
                  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                 where t.invoice_id = i.invoice_id
                   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   and t.rowstate = 'Posted'
                   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV' --in ('INV', 'PKG')
                   and i.invoice_date between
                       add_months(to_date('&from_date', 'yyyy/mm/dd'), -3) and
                       add_months(to_date('&to_date', 'yyyy/mm/dd'), -3)
                 group by extract(year from i.invoice_date),
                          extract(month from i.invoice_date),
                          t.c10,
                          t.c5) ns3
         inner join IFSAPP.INVENT_ONLINE_COST_TAB b
            on ns3.YEAR = b.year
           and ns3.PERIOD = b.period
           and ns3.SITE = b.contract
           and ns3.PRODUCT_CODE = b.part_no
        
        union all
        
        --PKG Cost of Sales
        select ps.YEAR, --Current Month PKG Cost of Sales
               ps.PERIOD,
               ps.SITE,
               ps.catalog_no PRODUCT_CODE,
               ps.SALES_QUANTITY,
               b.cost,
               (ps.SALES_QUANTITY * b.cost) cost_of_sales
          from (select extract(year from i.invoice_date) "YEAR",
                       extract(month from i.invoice_date) PERIOD,
                       t.c10 "SITE",
                       p.catalog_no,
                       sum((case
                             when t.net_curr_amount != 0 then
                              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                             else
                              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                                 t.item_id,
                                                                 T.N2)
                           end) * p.qty_per_assembly) SALES_QUANTITY
                  from ifsapp.invoice_item_tab t
                 inner join ifsapp.INVOICE_TAB i
                    on t.invoice_id = i.invoice_id
                 inner join ifsapp.sales_part_package_tab p
                    on t.c10 = p.contract
                   and t.c5 = p.parent_part
                 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   and t.rowstate = 'Posted'
                   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'PKG'
                   and i.invoice_date between
                       to_date('&from_date', 'yyyy/mm/dd') and
                       to_date('&to_date', 'yyyy/mm/dd')
                 group by extract(year from i.invoice_date),
                          extract(month from i.invoice_date),
                          t.c10,
                          p.catalog_no) ps
         inner join IFSAPP.INVENT_ONLINE_COST_TAB b
            on ps.YEAR = b.year
           and ps.PERIOD = b.period
           and ps.SITE = b.contract
           and ps.catalog_no = b.part_no
        
        union all
        
        --Previous Month PKG Cost of Sales
        select ps1.YEAR,
               ps1.PERIOD,
               ps1.SITE,
               ps1.catalog_no PRODUCT_CODE,
               ps1.SALES_QUANTITY,
               b.cost,
               (ps1.SALES_QUANTITY * b.cost) cost_of_sales
          from (select extract(year from i.invoice_date) "YEAR",
                       extract(month from i.invoice_date) PERIOD,
                       t.c10 "SITE",
                       p.catalog_no,
                       sum((case
                             when t.net_curr_amount != 0 then
                              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                             else
                              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                                 t.item_id,
                                                                 T.N2)
                           end) * p.qty_per_assembly) SALES_QUANTITY
                  from ifsapp.invoice_item_tab t
                 inner join ifsapp.INVOICE_TAB i
                    on t.invoice_id = i.invoice_id
                 inner join ifsapp.sales_part_package_tab p
                    on t.c10 = p.contract
                   and t.c5 = p.parent_part
                 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   and t.rowstate = 'Posted'
                   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'PKG'
                   and i.invoice_date between
                       add_months(to_date('&from_date', 'yyyy/mm/dd'), -1) and
                       add_months(to_date('&to_date', 'yyyy/mm/dd'), -1)
                 group by extract(year from i.invoice_date),
                          extract(month from i.invoice_date),
                          t.c10,
                          p.catalog_no) ps1
         inner join IFSAPP.INVENT_ONLINE_COST_TAB b
            on ps1.YEAR = b.year
           and ps1.PERIOD = b.period
           and ps1.SITE = b.contract
           and ps1.catalog_no = b.part_no
        
        union all
        
        --2nd Previous Month PKG Cost of Sales
        select ps2.YEAR,
               ps2.PERIOD,
               ps2.SITE,
               ps2.catalog_no PRODUCT_CODE,
               ps2.SALES_QUANTITY,
               b.cost,
               (ps2.SALES_QUANTITY * b.cost) cost_of_sales
          from (select extract(year from i.invoice_date) "YEAR",
                       extract(month from i.invoice_date) PERIOD,
                       t.c10 "SITE",
                       p.catalog_no,
                       sum((case
                             when t.net_curr_amount != 0 then
                              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                             else
                              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                                 t.item_id,
                                                                 T.N2)
                           end) * p.qty_per_assembly) SALES_QUANTITY
                  from ifsapp.invoice_item_tab t
                 inner join ifsapp.INVOICE_TAB i
                    on t.invoice_id = i.invoice_id
                 inner join ifsapp.sales_part_package_tab p
                    on t.c10 = p.contract
                   and t.c5 = p.parent_part
                 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   and t.rowstate = 'Posted'
                   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'PKG'
                   and i.invoice_date between
                       add_months(to_date('&from_date', 'yyyy/mm/dd'), -2) and
                       add_months(to_date('&to_date', 'yyyy/mm/dd'), -2)
                 group by extract(year from i.invoice_date),
                          extract(month from i.invoice_date),
                          t.c10,
                          p.catalog_no) ps2
         inner join IFSAPP.INVENT_ONLINE_COST_TAB b
            on ps2.YEAR = b.year
           and ps2.PERIOD = b.period
           and ps2.SITE = b.contract
           and ps2.catalog_no = b.part_no
        
        union all
        
        --3rd Previous Month PKG Cost of Sales
        select ps3.YEAR,
               ps3.PERIOD,
               ps3.SITE,
               ps3.catalog_no PRODUCT_CODE,
               ps3.SALES_QUANTITY,
               b.cost,
               (ps3.SALES_QUANTITY * b.cost) cost_of_sales
          from (select extract(year from i.invoice_date) "YEAR",
                       extract(month from i.invoice_date) PERIOD,
                       t.c10 "SITE",
                       p.catalog_no,
                       sum((case
                             when t.net_curr_amount != 0 then
                              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                             else
                              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                                 t.item_id,
                                                                 T.N2)
                           end) * p.qty_per_assembly) SALES_QUANTITY
                  from ifsapp.invoice_item_tab t
                 inner join ifsapp.INVOICE_TAB i
                    on t.invoice_id = i.invoice_id
                 inner join ifsapp.sales_part_package_tab p
                    on t.c10 = p.contract
                   and t.c5 = p.parent_part
                 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   and t.rowstate = 'Posted'
                   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'PKG'
                   and i.invoice_date between
                       add_months(to_date('&from_date', 'yyyy/mm/dd'), -2) and
                       add_months(to_date('&to_date', 'yyyy/mm/dd'), -2)
                 group by extract(year from i.invoice_date),
                          extract(month from i.invoice_date),
                          t.c10,
                          p.catalog_no) ps3
         inner join IFSAPP.INVENT_ONLINE_COST_TAB b
            on ps3.YEAR = b.year
           and ps3.PERIOD = b.period
           and ps3.SITE = b.contract
           and ps3.catalog_no = b.part_no) csl
 where csl.SITE not in ('BSCP', --Service Center
                        'BLSP',
                        'CLSP',
                        'CSCP',
                        'DSCP',
                        'JSCP',
                        'MSCP', --New Service Center
                        'RSCP',
                        'SSCP',
                        'MS1C',
                        'MS2C',
                        'BTSC',
                        'APWH', --Warehouse
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
                        'ABWW', --Wholesale Warehouse
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
                        'TUWW', --All Warehouses
                        'SACF',
                        'SAVF',
                        'SFRF',
                        'SCAF', /*Cable Factory*/ --Factory Site
                        'JWSS',
                        'SAOS',
                        'SWSS',
                        'WSMO', --Wholesale Sites
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
 group by csl.YEAR, csl.PERIOD, csl.SITE
 order by csl.YEAR, csl.PERIOD, csl.SITE
