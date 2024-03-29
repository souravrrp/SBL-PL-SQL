--Inventory Turn Over by NSP
select r.stat_year,
       r.stat_period_no,
       r.contract,
       r.part_no,
       IFSAPP.INVENTORY_PART_API.Get_Description(r.contract, r.part_no) part_desc,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         r.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             r.part_no)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 r.part_no)) commodity_group2,
       ((r.bf_balance + r.cf_balance) / 2) avg_inv_qtn,
       nvl((select (l.sales_price - --Find discounted sales price
                  nvl((select d.amount --Find running promotinal discount on CO in Retail/All Channel
                         from IFSAPP.SBL_DISCOUNT_PROMOTION d
                        where last_day(to_date('&year_i' || '/' ||
                                               '&period' || '/1',
                                               'YYYY/MM/DD')) between
                              d.valid_from and d.valid_to
                          and d.transaction_no = 2
                          and d.channel in ('ALL', '24')
                          and d.part_no = l.catalog_no),
                       0))
             from IFSAPP.SALES_PRICE_LIST_PART l
            inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                              lp.catalog_no,
                              min(abs(lp.valid_from_date -
                                      last_day(to_date('&year_i' || '/' ||
                                                       '&period' || '/1',
                                                       'YYYY/MM/DD')))) diff
                         from IFSAPP.SALES_PRICE_LIST_PART lp
                        where lp.valid_from_date <=
                              last_day(to_date('&year_i' || '/' ||
                                               '&period' || '/1',
                                               'YYYY/MM/DD'))
                        group by lp.price_list_no, lp.catalog_no) m
               on l.price_list_no = m.price_list_no
              and l.catalog_no = m.catalog_no
            where abs(l.valid_from_date -
                      last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                       'YYYY/MM/DD'))) = m.diff
              and l.price_list_no = '1'
              and l.catalog_no = r.part_no),
           0) discounted_nsp,
       (((r.bf_balance + r.cf_balance) / 2) *
       nvl((select (l.sales_price - --Find discounted sales price
                   nvl((select d.amount --Find running promotinal discount on CO in Retail/All Channel
                          from IFSAPP.SBL_DISCOUNT_PROMOTION d
                         where last_day(to_date('&year_i' || '/' ||
                                                '&period' || '/1',
                                                'YYYY/MM/DD')) between
                               d.valid_from and d.valid_to
                           and d.transaction_no = 2
                           and d.channel in ('ALL', '24')
                           and d.part_no = l.catalog_no),
                        0))
              from IFSAPP.SALES_PRICE_LIST_PART l
             inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                               lp.catalog_no,
                               min(abs(lp.valid_from_date -
                                       last_day(to_date('&year_i' || '/' ||
                                                        '&period' || '/1',
                                                        'YYYY/MM/DD')))) diff
                          from IFSAPP.SALES_PRICE_LIST_PART lp
                         where lp.valid_from_date <=
                               last_day(to_date('&year_i' || '/' ||
                                                '&period' || '/1',
                                                'YYYY/MM/DD'))
                         group by lp.price_list_no, lp.catalog_no) m
                on l.price_list_no = m.price_list_no
               and l.catalog_no = m.catalog_no
             where abs(l.valid_from_date -
                       last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                        'YYYY/MM/DD'))) = m.diff
               and l.price_list_no = '1'
               and l.catalog_no = r.part_no),
            0)) inv_value,
       nvl(s.SALES_QUANTITY, 0) SALES_QUANTITY,
       nvl(s.SALES_PRICE, 0) sales_value,
       case
         when nvl(s.SALES_PRICE, 0) != 0 then
          round((((r.bf_balance + r.cf_balance) / 2) *
          nvl((select (l.sales_price - --Find discounted sales price
                       nvl((select d.amount --Find running promotinal discount on CO in Retail/All Channel
                              from IFSAPP.SBL_DISCOUNT_PROMOTION d
                             where last_day(to_date('&year_i' || '/' ||
                                                    '&period' || '/1',
                                                    'YYYY/MM/DD')) between
                                   d.valid_from and d.valid_to
                               and d.transaction_no = 2
                               and d.channel in ('ALL', '24')
                               and d.part_no = l.catalog_no),
                            0))
                  from IFSAPP.SALES_PRICE_LIST_PART l
                 inner join (select lp.price_list_no, --Find the difference between cutoff date and last price date
                                   lp.catalog_no,
                                   min(abs(lp.valid_from_date -
                                           last_day(to_date('&year_i' || '/' ||
                                                            '&period' || '/1',
                                                            'YYYY/MM/DD')))) diff
                              from IFSAPP.SALES_PRICE_LIST_PART lp
                             where lp.valid_from_date <=
                                   last_day(to_date('&year_i' || '/' ||
                                                    '&period' || '/1',
                                                    'YYYY/MM/DD'))
                             group by lp.price_list_no, lp.catalog_no) m
                    on l.price_list_no = m.price_list_no
                   and l.catalog_no = m.catalog_no
                 where abs(l.valid_from_date -
                           last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                            'YYYY/MM/DD'))) = m.diff
                   and l.price_list_no = '1'
                   and l.catalog_no = r.part_no),
                0)) / nvl(s.SALES_PRICE, 0), 2)
         else
          0
       end "ratio"
  from ifsapp.REP246_TAB r
  left join (select extract(year from i.invoice_date) "YEAR",
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
                and i.invoice_date between
                    to_date('&from_date', 'yyyy/mm/dd') and
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
                               t.n2 *
                               (t.net_curr_amount / abs(t.net_curr_amount))
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
                        and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) =
                            'PKG'
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
                                          'CITF')) c --Trade Fair
              where c.invoice_date between
                    to_date('&from_date', 'yyyy/mm/dd') and
                    to_date('&to_date', 'yyyy/mm/dd')
              group by extract(year from c.invoice_date),
                       extract(month from c.invoice_date),
                       c.c10,
                       c.catalog_no) s
    on r.stat_year = s.YEAR
   and r.stat_period_no = s.PERIOD
   and r.contract = s.SITE
   and r.part_no = s.PRODUCT_CODE
 where r.stat_year = '&year_i'
   and r.stat_period_no = '&period'
   and (r.bf_balance > 0 or r.cf_balance > 0)
   and r.contract not in ('BSCP',
                          'BLSP',
                          'CLSP', --New Service Center
                          'CSCP',
                          'DSCP',
                          'JSCP',
                          'RSCP',
                          'SSCP',
                          'MS1C',
                          'MS2C',
                          'BTSC') --Service Sites
   and r.Contract not in ('APWH',
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
                          'TWHW') --All Warehouses
   and r.contract not in ('SACF', 'SAVF', 'SFRF', 'SCAF' /*Cable Factory*/) --Factory Site
   and r.contract not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
   and r.contract not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM') --Corporate, Employee, & Scrap Sites
   and r.contract not in ('DITF', 'CITF') --Trade Fair Sites
 order by 3, 4
