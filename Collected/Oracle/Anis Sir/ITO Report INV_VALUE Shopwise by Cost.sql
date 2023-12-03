--Shopwise Inventory Value
select i.YEAR,
       i.PERIOD,
       i.site,
       (select sh.area_code
          from SHOP_DTS_INFO sh
         where sh.shop_code = i.site) area_code,
       (select sh.district_code
          from SHOP_DTS_INFO sh
         where sh.shop_code = i.site) district_code,
       round(sum(inv_value), 2) inv_value
  from (select b.year, --Current Month Inventory Value
               b.period,
               b.site,
               b.location,
               b.part_no,
               b.product_family,
               b.product_line,
               b.closing_bal,
               b.in_transit,
               b.cost,
               ((b.closing_bal + b.in_transit) * b.cost) inv_value
          from IFSAPP.INVENTORY_BALANCE b
         where b.year = '&year_i'
           and b.period = '&period'
        
        union all
        
        --Previous Month Inventory Value
        select b.year,
               b.period,
               b.site,
               b.location,
               b.part_no,
               b.product_family,
               b.product_line,
               b.closing_bal,
               b.in_transit,
               b.cost,
               ((b.closing_bal + b.in_transit) * b.cost) inv_value
          from IFSAPP.INVENTORY_BALANCE b
         where b.year = extract(year from add_months(to_date('&year_i' || '/' ||
                                                   '&period' || '/1',
                                                   'YYYY/MM/DD'),
                                           -1))
           and b.period = extract(month from add_months(to_date('&year_i' || '/' ||
                                                     '&period' || '/1',
                                                     'YYYY/MM/DD'),
                                             -1))
        
        union all
        
        --2nd Previous Month Inventory Value
        select b.year,
               b.period,
               b.site,
               b.location,
               b.part_no,
               b.product_family,
               b.product_line,
               b.closing_bal,
               b.in_transit,
               b.cost,
               ((b.closing_bal + b.in_transit) * b.cost) inv_value
          from IFSAPP.INVENTORY_BALANCE b
         where b.year = extract(year from add_months(to_date('&year_i' || '/' ||
                                                   '&period' || '/1',
                                                   'YYYY/MM/DD'),
                                           -2))
           and b.period = extract(month from add_months(to_date('&year_i' || '/' ||
                                                     '&period' || '/1',
                                                     'YYYY/MM/DD'),
                                             -2))
        
        union all
        
        --3rd Previous Month Inventory Value
        select b.year,
               b.period,
               b.site,
               b.location,
               b.part_no,
               b.product_family,
               b.product_line,
               b.closing_bal,
               b.in_transit,
               b.cost,
               ((b.closing_bal + b.in_transit) * b.cost) inv_value
          from IFSAPP.INVENTORY_BALANCE b
         where b.year = extract(year from add_months(to_date('&year_i' || '/' ||
                                                   '&period' || '/1',
                                                   'YYYY/MM/DD'),
                                           -3))
           and b.period = extract(month from add_months(to_date('&year_i' || '/' ||
                                                     '&period' || '/1',
                                                     'YYYY/MM/DD'),
                                             -3))) i

 where i.site not in ('BSCP', --Service Center
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
                      'CITF') --Corporate, Employee, & Scrap Sites
 group by i.YEAR, i.PERIOD, i.site
 order by i.YEAR, i.PERIOD, 5, i.site
