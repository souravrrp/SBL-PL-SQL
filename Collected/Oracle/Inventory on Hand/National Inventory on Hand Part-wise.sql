--National Inventory on Hand Part-wise
select i.part_no, p.product_family, sum(i.qty_onhand) qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on i.part_no = p.product_code
 where i.qty_onhand > 0
   and ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM', i.part_no) not in
       ('RBOOK', 'GIFT VOUCHER')
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', i.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', i.part_no) not like
       'S-%'
   and i.part_no like '&PART_NO'
   and i.contract /*not*/ in ('BSCP',
                          'BLSP',
                          'CLSP',
                          'CSCP',
                          'CXSP',
                          'DSCP',
                          'FSCP', --New Service Center
                          'JSCP',
                          'KSCP',
                          'MSCP',
                          'NSCP',
                          'RPSP',
                          'RSCP',
                          'SSCP',
                          'MS1C',
                          'MS2C',
                          'BTSC') --Service Sites
/*AND p.product_family IN ('REFRIGERATOR-DIRECT-COOL',
'REFRIGERATOR-SIDE-BY-SIDE',
'REFRIGERATOR-NOFROST',
'REFRIGERATOR-FREEZER',
'REFRIGERATOR-SEMI-COMM')*/
 group by I.part_no, p.product_family
 ORDER BY 2, 1
