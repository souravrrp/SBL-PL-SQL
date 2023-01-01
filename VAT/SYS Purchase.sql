/* Formatted on 12/18/2022 1:17:10 PM (QP5 v5.381) */
  SELECT r.part_no,
         SUM (r.qty_arrived)     quantity,
         SUM (
               ifsapp.purchase_order_line_api.get_buy_unit_price (r.order_no,
                                                                  r.line_no,
                                                                  r.release_no)
             * r.qty_arrived)    total_price
    FROM ifsapp.purchase_receipt_new r
   WHERE     ifsapp.identity_invoice_info_api.get_group_id ('SBL',
                                                            r.vendor_no,
                                                            'Supplier') =
             '0'
         AND ifsapp.inventory_part_api.get_part_product_family (r.contract,
                                                                r.part_no) NOT IN
                 ('RBOOK', 'GV')
         AND TRUNC (r.arrival_date) BETWEEN :P_FROM_DATE AND :P_TO_DATE
         AND r.state != 'Cancelled'
GROUP BY r.part_no;