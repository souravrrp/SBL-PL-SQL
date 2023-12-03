--Shop Inventory on Hand Part-wise
select i.part_no, p.product_family, sum(i.qty_onhand) qty_onhand
  from IFSAPP.INVENTORY_PART_IN_STOCK i
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on i.part_no = p.product_code
 inner join IFSAPP.SHOP_DTS_INFO S
    on i.contract = s.shop_code
 where i.qty_onhand > 0
   and ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM', i.part_no) !=
       'RBOOK'
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', i.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', i.part_no) not like
       'S-%'
   and i.part_no like '&PART_NO'
 group by I.part_no, p.product_family
 ORDER BY 2, 1
