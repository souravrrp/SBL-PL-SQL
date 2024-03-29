--Shopwise On Transit Inventory
select s.area_code,
       s.district_code,
       m.contract as Request_Site,
       IFSAPP.Site_Api.Get_Description(m.contract) request_site_description,
       p.product_family,
       m.part_no,
       p.product_desc,
       sum(m.qty) qtn
  FROM ifsapp.inv_transit_tracking m,
       SBL_JR_PRODUCT_DTL_INFO     p,
       SHOP_DTS_INFO               S
 where p.PRODUCT_CODE = m.part_no
   AND M.contract = S.SHOP_CODE
   AND m.qty > 0
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', m.part_no) !=
       'RBOOK'
   AND ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', m.part_no) !=
       'RAW'
   AND ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', m.part_no) not like
       'S-%'
   /*and p.PRODUCT_FAMILY IN ('REFRIGERATOR-DIRECT-COOL',
                            'REFRIGERATOR-FREEZER',
                            'REFRIGERATOR-NOFROST',
                            'REFRIGERATOR-SIDE-BY-SIDE',
                            'REFRIGERATOR-SEMI-COMM')*/
 group by s.area_code,
          s.district_code,
          m.contract,
          p.product_family,
          m.part_no,
          p.product_desc
 ORDER BY s.area_code,
          s.district_code,
          m.contract,
          p.product_family,
          m.part_no
