--INV Sales
select extract(year from i.invoice_date) "YEAR",
       extract(month from i.invoice_date) PERIOD,
       t.c10 "SITE",
       t.c5 PRODUCT_CODE,
       sum(case
             when t.net_curr_amount != 0 then
              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
             else
              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2)
           end) SALES_QUANTITY,
       sum(t.net_curr_amount) SALES_PRICE
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV' --in ('INV', 'PKG')
   and t.c10 not in ('BSCP', --Service Sites 
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
                     'DITF',
                     'CITF') --Trade Fair
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
 group by extract(year from i.invoice_date),
          extract(month from i.invoice_date),
          t.c10,
          t.c5

union all

--PKG Sales
select extract(year from c.invoice_date) "YEAR",
       extract(month from c.invoice_date) PERIOD,
       c.c10 "SITE",
       c.catalog_no,
       sum(c.SALES_QUANTITY) SALES_QUANTITY,
       sum(c.comp_price) comp_price
  from (select i.invoice_date,
               t.c10,
               t.c1,
               t.c5,
               p.catalog_no,
               ((case
                 when t.net_curr_amount != 0 then
                  t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                 else
                  IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                     t.item_id,
                                                     T.N2)
               end) * p.qty_per_assembly) SALES_QUANTITY,
               t.net_curr_amount SALES_PRICE,
               ifsapp.GET_SBL_COMP_RATIO_IN_PKG(t.c5,
                                                p.catalog_no,
                                                t.c10,
                                                i.invoice_date) comp_ratio,
               (t.net_curr_amount *
               ifsapp.GET_SBL_COMP_RATIO_IN_PKG(t.c5,
                                                 p.catalog_no,
                                                 t.c10,
                                                 i.invoice_date)) comp_price
          from ifsapp.invoice_item_tab t
         inner join ifsapp.INVOICE_TAB i
            on t.invoice_id = i.invoice_id
         inner join ifsapp.sales_part_package_tab p
            on t.c10 = p.contract
           and t.c5 = p.parent_part
         where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           and t.rowstate = 'Posted'
           and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'PKG'
           and t.c10 not in ('BSCP', --Service Sites 
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
                             'DITF',
                             'CITF')) c--Trade Fair
 where c.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
 group by extract(year from c.invoice_date),
          extract(month from c.invoice_date),
          c.c10,
          c.catalog_no
 order by 4
