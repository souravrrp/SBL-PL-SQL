/* Formatted on 4/3/2023 9:34:23 AM (QP5 v5.381) */
SELECT ROW_NUMBER ()
           OVER (PARTITION BY splpt.catalog_no, splpt.price_list_no
                 ORDER BY splpt.valid_from_date DESC)
           row_num,
       ifsapp.sales_part_api.get_catalog_desc ('SCOM', splpt.catalog_no)
           part_desc,
       ifsapp.inventory_product_code_api.get_description (
           ifsapp.inventory_part_api.get_part_product_code ('SCOM',
                                                            splpt.catalog_no))
           brand,
       DECODE (
           ifsapp.sales_part_api.get_catalog_type (splpt.catalog_no),
           'PKG', ifsapp.inventory_product_family_api.get_description (
                      ifsapp.sales_part_api.get_part_product_family (
                          'SCOM',
                          splpt.catalog_no)),
           ifsapp.inventory_product_family_api.get_description (
               ifsapp.inventory_part_api.get_part_product_family (
                   'SCOM',
                   splpt.catalog_no)))
           product_family,
       DECODE (
           ifsapp.sales_part_api.get_catalog_type (splpt.catalog_no),
           'PKG', ifsapp.sales_group_api.get_description (
                      ifsapp.sales_part_api.get_catalog_group (
                          'SCOM',
                          splpt.catalog_no)),
           ifsapp.commodity_group_api.get_description (
               ifsapp.inventory_part_api.get_second_commodity (
                   'SCOM',
                   splpt.catalog_no)))
           commodity_group2,
       ifsapp.statutory_fee_api.get_fee_rate (splpt.company,
                                              splpt.cash_tax_code)
           vat_rate,
       splpt.price_list_no,
       splpt.catalog_no,
       splpt.min_quantity,
       splpt.valid_from_date,
       splpt.base_price_site,
       splpt.base_price,
       splpt.percentage_offset,
       splpt.amount_offset,
       splpt.rounding,
       splpt.last_updated,
       splpt.sales_price,
       splpt.discount_type,
       splpt.discount,
       splpt.rowversion,
       splpt.hp_sales_price,
       splpt.cash_tax_code,
       splpt.hp_tax_code,
       splpt.company
  FROM ifsapp.sales_price_list_part_tab splpt
 WHERE     1 = 1
       AND splpt.price_list_no = NVL ( :p_price_list_no, splpt.price_list_no)
       AND (   :p_product_code IS NULL
            OR (UPPER (splpt.catalog_no) LIKE
                    UPPER ('%' || :p_product_code || '%')))
       AND ( :p_shop_code IS NULL OR (splpt.base_price_site = :p_shop_code))
       AND TRUNC (splpt.valid_from_date) BETWEEN NVL (
                                                     :p_date_from,
                                                     TRUNC (
                                                         splpt.valid_from_date))
                                             AND NVL (
                                                     :p_date_to,
                                                     TRUNC (
                                                         splpt.valid_from_date));