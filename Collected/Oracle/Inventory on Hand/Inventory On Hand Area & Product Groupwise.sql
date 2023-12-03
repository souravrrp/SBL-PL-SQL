select b.area_code, b.Product_group, sum(b.QTY_ONHAND) QTY_ONHAND
  from (select s.area_code,
               ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                     aa.part_no)) Product_group,
               aa.part_no,
               sum(aa.QTY_ONHAND) as QTY_ONHAND
          from IFSAPP.INVENTORY_PART_IN_STOCK_TAB aa
         inner join IFSAPP.SHOP_DTS_INFO s
            on aa.contract = s.shop_code
         where aa.qty_onhand > 0
         group by s.area_code, aa.part_no) b
 group by b.area_code, b.Product_group
 order by 1, 2
