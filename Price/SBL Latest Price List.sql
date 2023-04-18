/* Formatted on 4/3/2023 9:29:40 AM (QP5 v5.381) */
SELECT ifsapp.sales_part_api.get_catalog_desc ('SCOM', slpl.catalog_no)
           part_desc,
       ifsapp.inventory_product_code_api.get_description (
           ifsapp.inventory_part_api.get_part_product_code ('SCOM',
                                                            slpl.catalog_no))
           brand,
       DECODE (
           ifsapp.sales_part_api.get_catalog_type (slpl.catalog_no),
           'PKG', ifsapp.inventory_product_family_api.get_description (
                      ifsapp.sales_part_api.get_part_product_family (
                          'SCOM',
                          slpl.catalog_no)),
           ifsapp.inventory_product_family_api.get_description (
               ifsapp.inventory_part_api.get_part_product_family (
                   'SCOM',
                   slpl.catalog_no)))
           product_family,
       DECODE (
           ifsapp.sales_part_api.get_catalog_type (slpl.catalog_no),
           'PKG', ifsapp.sales_group_api.get_description (
                      ifsapp.sales_part_api.get_catalog_group (
                          'SCOM',
                          slpl.catalog_no)),
           ifsapp.commodity_group_api.get_description (
               ifsapp.inventory_part_api.get_second_commodity (
                   'SCOM',
                   slpl.catalog_no)))
           commodity_group2,
       slpl.*
  FROM ifsapp.sbl_latest_price_list slpl
 WHERE     1 = 1
       AND slpl.price_list_no = NVL ( :p_price_list_no, slpl.price_list_no)
       AND slpl.catalog_no = NVL ( :p_catalog_no, slpl.catalog_no);