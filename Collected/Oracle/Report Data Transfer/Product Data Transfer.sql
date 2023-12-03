--*** Product Data Transfer INV
select I.part_no,
       I.description,
       'INV' PART_TYPE,
       I.part_product_code B_CODE,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(I.part_product_code) BRAND,
       I.part_product_family PF_CODE,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(I.part_product_family) PRODUCT_FAMILY,
       I.second_commodity CM2_CODE,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(I.second_commodity) COMMODITY_2
  from IFSAPP.INVENTORY_PART I
 where I.contract = 'SCOM'
   and ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM', i.part_no) !=
       'RBOOK'
   AND ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', i.part_no) !=
       'RAW'
   AND ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', i.part_no) not like
       'S-%'
 ORDER BY 1


--*** Product Data Transfer PKG
select S.catalog_no,
       S.catalog_desc,
       S.catalog_type_db,
       '' B_CODE,
       '' BRAND,
       S.part_product_family PF_CODE,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(S.part_product_family) PRODUCT_FAMILY,
       S.catalog_group CM2_CODE, -- SG_CODE
       IFSAPP.SALES_GROUP_API.Get_Description(S.catalog_group) COMMODITY_2 -- SALES_GROUP
  from IFSAPP.SALES_PART S
 WHERE S.contract = 'SCOM'
   AND S.catalog_type_db = 'PKG'
 ORDER BY 1
