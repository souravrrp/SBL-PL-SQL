select t.*,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.SALE_PART_NO)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.SALE_PART_NO)) product_family,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      t.SALE_PART_NO)) sales_group
  from IFSAPP.SBL_LATEST_PRICE_LIST T
 where T.PRICE_LIST_NO = '&PRICE_LIST_NO'
   and T.SALE_PART_NO LIKE '%&CATALOG_NO%'
