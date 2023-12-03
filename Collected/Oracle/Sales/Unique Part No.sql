select distinct v.catalog_no     part_no,
                v.catalog_desc   part_desc,
                v.brand,
                v.product_family,
                v.sales_group
  from (select s.contract,
               s.catalog_no,
               s.catalog_desc,
               IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(s.contract,
                                                                                                                 s.catalog_no)) brand,
               ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(s.contract,
                                                                                                                     s.catalog_no)) product_family,
               IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group(s.contract,
                                                                                              s.catalog_no)) sales_group
          from IFSAPP.SALES_PART s
         where IFSAPP.SALES_PART_API.Get_Catalog_Group(S.contract,
                                                       s.catalog_no) not in
               ('ADORM', 'AVRML', 'SRCRM', '*', 'RBOOK', 'TR')
           and IFSAPP.SALES_PART_API.Get_Catalog_Group(s.contract,
                                                       s.catalog_no) not LIKE
               'S-%') v
 order by 1

/*AUDIO VIDEO RAW MATERIALS
AV RAW MATERIAL- LOCAL
CABLES RAW MATERIALS
IFS Applications
RBOOK
TRADE IN - TR*/
