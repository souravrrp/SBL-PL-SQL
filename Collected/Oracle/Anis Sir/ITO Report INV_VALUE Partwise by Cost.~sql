--Partwise Inventory Value
select i.YEAR,
       i.PERIOD,
       i.part_no,
       IFSAPP.INVENTORY_PART_API.Get_Description('SCOM', i.part_no) part_desc,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         i.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             i.part_no)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 i.part_no)) commodity_group2,
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

 where i.site not in ('BSCP',
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
   and i.site not in ('APWH',
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
   and i.site not in ('SACF', 'SAVF', 'SFRF', 'SCAF' /*Cable Factory*/) --Factory Site
   and i.site not in
       ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'DWWH', 'SCOM', 'DITF') --Wholesale Sites
   and i.site not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM') --Corporate, Employee, & Scrap Sites
 group by i.YEAR, i.PERIOD, i.part_no
 order by i.YEAR, i.PERIOD, i.part_no
