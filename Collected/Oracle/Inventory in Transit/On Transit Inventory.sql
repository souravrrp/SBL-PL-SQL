--Inventory on Transit Palash
select p.group_no,
       (SELECT i.PRODUCT_GROUP
          FROM PRODUCT_INFO I
         WHERE I.GROUP_NO = p.group_no) GROUP_NAME,
       sum(qty) QTY
  FROM ifsapp.inv_transit_tracking m, product_category_info p
 WHERE p.PRODUCT_CODE = m.PART_NO
   and m.qty > 0      
   AND M.CONTRACT IN (SELECT SHOP_CODE FROM SHOP_DTS_INFO)
   AND P.GROUP_NO = 102
 group by p.group_no;


--Inventory on Transit Jasper
select DI.PRODUCT_FAMILY Product_Group, sum(tt.qty) QTY
  from INV_TRANSIT_TRACKING tt, SBL_JR_PRODUCT_DTL_INFO DI, SHOP_DTS_INFO S
 where tt.part_no = DI.PRODUCT_CODE
   AND TT.contract = S.SHOP_CODE
   and tt.qty > 0
   and DI.PRODUCT_FAMILY IN ('REFRIGERATOR-DIRECT-COOL',
                             'REFRIGERATOR-FREEZER',
                             'REFRIGERATOR-NOFROST',
                             'REFRIGERATOR-SIDE-BY-SIDE',
                             'REFRIGERATOR-SEMI-COMM')
 group by DI.PRODUCT_FAMILY;

--Inventory on Transit Site-wise
select t.contract,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(t.contract,
                                                                                                             t.part_no)) product_family,
       t.part_no,
       sum(t.qty) QTY_IN_TRANSIT
  from IFSAPP.INV_TRANSIT_TRACKING t
 where t.qty > 0
   and ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM', t.part_no) not in
       ('RBOOK', 'GV')
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', t.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('DSCP', t.part_no) not like
       'S-%'
   and t.part_no like '%REF-%'
   and t.contract in
      /*(select w.ware_house_name
       from IFSAPP.WARE_HOUSE_INFO w
      where w.ware_house_name not like '%WW'
        AND
           \*or*\
            w.ware_house_name != 'DWWH'
        and w.ware_house_name not like '%CW')*/
       (select s.shop_code
          from ifsapp.shop_dts_info s
         where s.shop_code = t.contract)
 group by t.contract, t.part_no
 order by t.contract, t.part_no
