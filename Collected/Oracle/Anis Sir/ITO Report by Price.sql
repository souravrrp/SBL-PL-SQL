--Inventory Turn Over
select t.stat_year,
       t.stat_period_no,
       t.contract,
       t.part_no,
       IFSAPP.INVENTORY_PART_API.Get_Description(t.contract, t.part_no) part_desc,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.part_no)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 t.part_no)) commodity_group2,
       /*IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
       t.part_no)) sales_group,*/
       t.bf_balance,
       nvl((select (l.sales_price -
                  nvl((select d.amount
                         from IFSAPP.SBL_DISCOUNT_PROMOTION d
                        where to_date('&year_i' || '/' || '&period' || '/1',
                                      'YYYY/MM/DD') between d.valid_from and
                              d.valid_to
                          and d.part_no = l.catalog_no),
                       0))
             from IFSAPP.SALES_PRICE_LIST_PART l
            inner join (select lp.price_list_no,
                              lp.catalog_no,
                              min(abs(lp.valid_from_date -
                                      to_date('&year_i' || '/' || '&period' || '/1',
                                              'YYYY/MM/DD'))) diff
                         from IFSAPP.SALES_PRICE_LIST_PART lp
                        where lp.valid_from_date <=
                              to_date('&year_i' || '/' || '&period' || '/1',
                                      'YYYY/MM/DD')
                        group by lp.price_list_no, lp.catalog_no) m
               on l.price_list_no = m.price_list_no
              and l.catalog_no = m.catalog_no
            where abs(l.valid_from_date -
                      to_date('&year_i' || '/' || '&period' || '/1',
                              'YYYY/MM/DD')) = m.diff
              and l.price_list_no = '3'
              and l.catalog_no = t.part_no),
           0) op_discounted_nsp,
       t.cf_balance,
       nvl((select (l.sales_price - nvl((select d.amount
                                         from IFSAPP.SBL_DISCOUNT_PROMOTION d
                                        where last_day(to_date('&year_i' || '/' ||
                                                               '&period' || '/1',
                                                               'YYYY/MM/DD')) between
                                              d.valid_from and d.valid_to
                                          and d.part_no = l.catalog_no),
                                       0))
             from IFSAPP.SALES_PRICE_LIST_PART l
            inner join (select lp.price_list_no,
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
                        group by lp.price_list_no, lp.catalog_no) n
               on l.price_list_no = n.price_list_no
              and l.catalog_no = n.catalog_no
            where abs(l.valid_from_date -
                      last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                       'YYYY/MM/DD'))) = n.diff
              and l.price_list_no = '3'
              and l.catalog_no = t.part_no),
           0) cl_discounted_nsp
  from ifsapp.REP246_TAB t
 where t.stat_year = '&year_i'
   and t.stat_period_no = '&period'
   and t.bf_balance > 0
      /*and t.cf_balance > 0*/
   and t.contract not in ('BSCP',
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
   and t.Contract not in ('APWH',
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
   and t.contract not in ('SACF', 'SAVF', 'SFRF', 'SCAF' /*Cable Factory*/) --Factory Site
   and t.contract not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
   and t.contract not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM') --Corporate, Employee, & Scrap Sites
