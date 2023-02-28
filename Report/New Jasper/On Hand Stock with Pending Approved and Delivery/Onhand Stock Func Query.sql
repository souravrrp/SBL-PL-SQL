/* Formatted on 2/15/2023 9:58:50 AM (QP5 v5.381) */
SELECT SUM (pending_quantity)     qty
  FROM (SELECT pot.order_no
                   po_no,
               (CASE
                    WHEN (    SUBSTR (pot.order_no, 0, 2) = 'A-'
                          AND SUBSTR (pot.contract, 4, 4) != 'P')
                    THEN
                        'Retail'
                    WHEN (SUBSTR (pot.order_no, 0, 2) = 'W-')
                    THEN
                        'Wholesale'
                    WHEN (SUBSTR (pot.order_no, 0, 2) = 'I-')
                    THEN
                        'Corp'
                    WHEN (    SUBSTR (pot.order_no, 0, 2) = 'A-'
                          AND SUBSTR (pot.contract, 4, 4) = 'P')
                    THEN
                        'Service Center'
                    WHEN (SUBSTR (pot.order_no, 0, 2) = 'O-')
                    THEN
                        'Online'
                    ELSE
                        'Others'
                END)
                   channel,
               pot.contract
                   order_from,
               pot.vendor_no
                   order_to,
               polt.part_no
                   sku,
               polt.buy_qty_due
                   po_quantity,
               ifsapp.purchase_order_line_api.get_line_total (
                   pot.order_no,
                   polt.line_no,
                   polt.release_no)
                   line_amount,
               NVL (rr.qty_arrived, 0)
                   receive_quantity,
               (polt.buy_qty_due - NVL (rr.qty_arrived, 0))
                   pending_quantity,
               TRUNC (pot.order_date)
                   po_date,
               pot.rowstate
                   po_status
          FROM ifsapp.purchase_order_tab       pot,
               ifsapp.purchase_order_line_tab  polt,
               (  SELECT r.order_no,
                         r.line_no,
                         r.release_no,
                         r.part_no,
                         SUM (r.qty_arrived)     qty_arrived
                    FROM ifsapp.purchase_receipt_new r
                   WHERE r.state = 'Received'
                GROUP BY r.order_no,
                         r.line_no,
                         r.release_no,
                         r.part_no) rr
         WHERE     pot.order_no = polt.order_no
               AND pot.rowstate NOT IN ('Cancelled', 'Closed')
               AND polt.rowstate NOT IN ('Cancelled', 'Closed')
               AND order_sent = 'SENT'
               AND polt.part_no = :p_sku
               AND EXISTS
                       (SELECT 1
                          FROM ifsapp.customer_order co
                         WHERE     1 = 1
                               AND co.customer_po_no = pot.order_no
                               AND co.state NOT IN
                                       ('Cancelled',
                                        'Closed',
                                        'Invoiced/Closed'))
               AND polt.order_no = rr.order_no(+)
               AND polt.line_no = rr.line_no(+)
               AND polt.release_no = rr.release_no(+)
               AND polt.part_no = rr.part_no(+))
 WHERE     1 = 1
       AND channel IN ('Retail',
                       'Wholesale',
                       'Corp',
                       'Online')
       AND pending_quantity > 0;