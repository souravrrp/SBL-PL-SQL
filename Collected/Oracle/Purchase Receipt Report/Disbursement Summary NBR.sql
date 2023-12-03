--Finished Goods received in Factory Site
SELECT EXTRACT(YEAR FROM R.arrival_date) "YEAR",
       EXTRACT(MONTH FROM R.arrival_date) "PERIOD",
       R.vendor_no WH_SITE,
       SUM(R.qty_arrived) TOTAL_QTY_ARRIVED,
       SUM(R.total_nsp) TOTAL_NSP
  FROM (select p.order_no,
               p.line_no,
               p.release_no,
               p.receipt_no,
               p.vendor_no,
               p.contract "SITE",
               p.part_no,
               p.description,
               /*IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                                 p.part_no)) brand,
               ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                     p.part_no)) product_family_description,
               IFSAPP.COMMODITY_GROUP_API.Get_Description(ifsapp.inventory_part_api.Get_Second_Commodity('SCOM',
                                                                                                         p.part_no)) comm_group_2,*/
               p.qty_arrived,
               ifsapp.get_sbl_sales_price('3',
                                          p.part_no,
                                          trunc(p.arrival_date)) unit_nsp,
               (p.qty_arrived *
               ifsapp.get_sbl_sales_price('3',
                                           p.part_no,
                                           trunc(p.arrival_date))) total_nsp,
               trunc(p.arrival_date) arrival_date,
               p.state
          from IFSAPP.PURCHASE_RECEIPT_NEW p
         where IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM',
                                                                 p.part_no) !=
               'RBOOK'
           and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                               p.part_no) !=
               'RAW'
           and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM',
                                                              p.part_no) not like
               'S-%'
              /*and p.part_no like '&part_no'*/
           and trunc(p.arrival_date) between
               to_date('&from_date', 'YYYY/MM/DD') and
               to_date('&to_date', 'YYYY/MM/DD')
           and p.state not in 'Cancelled'
           and p.vendor_no in ('APWH',
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
                               'TWHW')
           and p.contract not in ('APWH',
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
                                  'TUWW')) R
 GROUP BY EXTRACT(YEAR FROM R.arrival_date),
          EXTRACT(MONTH FROM R.arrival_date),
          R.vendor_no
 order by EXTRACT(YEAR FROM R.arrival_date),
          EXTRACT(MONTH FROM R.arrival_date),
          R.vendor_no
