/* Formatted on 2/9/2023 10:59:15 AM (QP5 v5.381) */
SELECT (SUM (v.qty_onhand * v.inv_value) / SUM (v.qty_onhand))     unit_cost
  FROM (  SELECT i.contract
                     "SITE",
                 (SELECT s.area_code
                    FROM ifsapp.shop_dts_info s
                   WHERE s.shop_code = i.contract)
                     area_code,
                 (SELECT s.district_code
                    FROM ifsapp.shop_dts_info s
                   WHERE s.shop_code = i.contract)
                     district_code,
                 i.part_no,
                 ifsapp.inventory_product_family_api.get_description (
                     ifsapp.inventory_part_api.get_part_product_family (
                         'SCOM',
                         i.part_no))
                     product_family,
                 ifsapp.inventory_product_code_api.get_description (
                     ifsapp.inventory_part_api.get_part_product_code (
                         'SCOM',
                         i.part_no))
                     brand,
                 ifsapp.commodity_group_api.get_description (
                     ifsapp.inventory_part_api.get_second_commodity ('SCOM',
                                                                     i.part_no))
                     commodity_group2,
                 SUM (i.qty_onhand)
                     qty_onhand,
                 (SELECT c.inventory_value
                    FROM ifsapp.inventory_part_unit_cost_tab c
                   WHERE c.part_no = i.part_no AND c.contract = i.contract)
                     inv_value
            FROM ifsapp.inventory_part_in_stock i
           WHERE     i.qty_onhand > 0
                 AND ifsapp.inventory_part_api.get_part_product_family (
                         i.contract,
                         i.part_no) NOT IN
                         ('RBOOK', 'GIFT VOUCHER')
                 AND ifsapp.inventory_part_api.get_part_product_code (
                         i.contract,
                         i.part_no) !=
                     'RAW'
                 AND ifsapp.inventory_part_api.get_second_commodity (
                         i.contract,
                         i.part_no) NOT LIKE
                         'S-%'
                 AND i.part_no = P_part_code
        GROUP BY i.contract, i.part_no) v;