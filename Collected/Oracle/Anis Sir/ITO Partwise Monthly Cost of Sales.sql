--Partwise Monthly Cost of Sales
select csl.YEAR,
       csl.PERIOD,
       csl.PRODUCT_CODE,
       sum(csl.SALES_QUANTITY) sales_unit,
       round(sum(cost_of_sales), 2) cost_of_sales
  from (select ns.YEAR, --INV
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
        
        select ps.YEAR, --PKG
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
           and ps.catalog_no = b.part_no) csl
 /*where csl.SITE not in ('BSCP', --Service Sites 
                        'BLSP',
                        'CLSP', --New Service Center
                        'CSCP',
                        'DSCP',
                        'JSCP',
                        'RSCP',
                        'SSCP',
                        'MS1C',
                        'MS2C',
                        'BTSC',
                        'JWSS', --Wholesale Sites
                        'SAOS',
                        'SWSS',
                        'WSMO',
                        'DWWH', --Wholesale Office
                        'SAPM', --Corporate, Employee, & Scrap Sites
                        'SCSM',
                        'SESM',
                        'SHOM',
                        'SISM',
                        'SFSM',
                        'DITF') */--Trade Fair
 group by csl.YEAR, csl.PERIOD, csl.PRODUCT_CODE
 order by csl.YEAR, csl.PERIOD, csl.PRODUCT_CODE
