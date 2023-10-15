/* Formatted on 5/3/2023 4:17:34 PM (QP5 v5.381) */
  SELECT r.order_no,
         r.line_no,
         r.release_no,
         r.receipt_no,
         r.vendor_no,
         ifsapp.supplier_info_api.get_name (r.vendor_no)
             vendor_name,
         r.contract,
         ifsapp.inventory_product_code_api.get_description (
             ifsapp.inventory_part_api.get_part_product_code ('SCOM',
                                                              r.part_no))
             brand,
         ifsapp.inventory_product_family_api.get_description (
             ifsapp.inventory_part_api.get_part_product_family ('SCOM',
                                                                r.part_no))
             product_family,
         r.part_no,
         r.qty_arrived,
         ifsapp.purchase_order_line_api.get_buy_unit_price (r.order_no,
                                                            r.line_no,
                                                            r.release_no)
             buy_unit_price,
         (  ifsapp.purchase_order_line_api.get_buy_unit_price (r.order_no,
                                                               r.line_no,
                                                               r.release_no)
          * r.qty_arrived)
             total_price,
         ifsapp.purchase_order_line_api.get_fbuy_unit_price (r.order_no,
                                                             r.line_no,
                                                             r.release_no)
             fbuy_unit_price,
         ifsapp.purchase_order_line_api.get_currency_rate (r.order_no,
                                                           r.line_no,
                                                           r.release_no)
             currency_rate,
         TRUNC (r.arrival_date)
             arrival_date,
         ifsapp.purchase_order_api.get_lc_no (r.order_no)
             lc_no,
         r.grn_no,
         r.shipment_id,
         r.state
    FROM ifsapp.purchase_receipt_new r
   WHERE     ifsapp.identity_invoice_info_api.get_group_id ('SBL',
                                                            r.vendor_no,
                                                            'Supplier') =
             '0'
         AND ifsapp.inventory_part_api.get_part_product_family (r.contract,
                                                                r.part_no) NOT IN
                 ('RBOOK', 'GV')
         AND ifsapp.inventory_part_api.get_part_product_code (r.contract,
                                                              r.part_no) !=
             'RAW'
         AND ifsapp.inventory_part_api.get_second_commodity (r.contract,
                                                             r.part_no) NOT LIKE
                 'S-%'
         AND TRUNC (r.arrival_date) BETWEEN NVL ( :p_date_from,
                                                 TRUNC (r.arrival_date))
                                        AND NVL ( :p_date_to,
                                                 TRUNC (r.arrival_date))
         AND r.state != 'Cancelled'
         AND (   :p_shop_code IS NULL OR (UPPER (r.contract) LIKE UPPER ('%' || :p_shop_code || '%')))
ORDER BY 1, 2