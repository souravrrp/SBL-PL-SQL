/* Formatted on 2/28/2023 12:40:27 PM (QP5 v5.381) */
SELECT pct.part_no,
       pct.description,
       --IFSAPP.sales_part_api.get_catalog_desc ('SCOM', pct.part_no) catalog_desc,
       ifsapp.inventory_part_api.get_part_product_code ('SCOM', pct.part_no)
           product_code,
       ifsapp.inventory_product_code_api.get_description (
           ifsapp.inventory_part_api.get_part_product_code ('SCOM',
                                                            pct.part_no))
           brand,
       DECODE (
           ifsapp.sales_part_api.get_catalog_type (pct.part_no),
           'PKG', ifsapp.inventory_product_family_api.get_description (
                      ifsapp.sales_part_api.get_part_product_family (
                          'SCOM',
                          pct.part_no)),
           ifsapp.inventory_product_family_api.get_description (
               ifsapp.inventory_part_api.get_part_product_family (
                   'SCOM',
                   pct.part_no)))
           product_family,
       DECODE (
           ifsapp.sales_part_api.get_catalog_type (pct.part_no),
           'PKG', ifsapp.sales_group_api.get_description (
                      ifsapp.sales_part_api.get_catalog_group ('SCOM',
                                                               pct.part_no)),
           ifsapp.commodity_group_api.get_description (
               ifsapp.inventory_part_api.get_second_commodity ('SCOM',
                                                               pct.part_no)))
           commodity_group2,
       ifsapp.sales_part_api.get_catalog_type (pct.part_no)
           part_catalog_type
  --,pct.*
  FROM ifsapp.part_catalog_tab pct
 WHERE     1 = 1
       AND (   :p_product_code IS NULL
            OR (UPPER (pct.part_no) LIKE
                    UPPER ('%' || :p_product_code || '%')))
       AND (   :p_product_description IS NULL
            OR (UPPER (pct.description) LIKE
                    UPPER ('%' || :p_product_description || '%')));