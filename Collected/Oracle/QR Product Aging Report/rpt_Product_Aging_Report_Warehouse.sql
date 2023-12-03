select v.shop_code,
       v.area_code,
       v.district_code,
       v.brand,
       v.product_family,
       v.product_family_description,
       v.comm_group_2,
       v.part_no,
       v.serial_no,
       v.Oem_No,
       v.qty_onhand,
       v.receipt_date,
       v.age,
       v.age_month,
       v.NSP,
       v.VAT_CODE,
       v.VAT,
       (select c.cost
          from ifsapp.invent_online_cost_tab c
         where c.year = extract(year from trunc(sysdate, 'mm') - 1)
           and c.period = extract(month from trunc(sysdate, 'mm') - 1)
           and c.contract = v.shop_code
           and c.part_no = v.part_no) UNIT_COST
  from ifsapp.sbl_vw_product_aging v
 WHERE v.shop_code in ('APWH',
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
                       'DWWH',
                       'ABWW',--Wholesale Warehouse
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
                       'TUWW')
   and v.product_family like '&product_family'
   and v.part_no like '&part_no'
   and v.age >= '&age'
 order by v.district_code,
          v.shop_code,
          v.product_family,
          v.part_no,
          v.receipt_date
