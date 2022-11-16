SELECT po_no,
       channel,
       order_from,
       order_to,
       sku,
       quantity,
       po_date,
       po_status
  FROM (SELECT pot.order_no                                    po_no,
               (CASE
                    WHEN     (SUBSTR (pot.order_no, 0, 2) = 'A-'
                         AND SUBSTR (pot.contract, 4, 4) != 'P')
                    THEN
                        'Retail'
                    WHEN (SUBSTR (pot.order_no, 0, 2) = 'W-')
                    THEN
                        'Wholease'
                    WHEN (SUBSTR (pot.order_no, 0, 2) = 'I-')
                    THEN
                        'Corp'
                    WHEN     (SUBSTR (pot.order_no, 0, 2) = 'A-'
                         AND SUBSTR (pot.contract, 4, 4) = 'P')
                    THEN
                        'Service Center'
                    WHEN (SUBSTR (pot.order_no, 0, 2) = 'O-')
                    THEN
                        'Online'
                    ELSE
                        'Others'
                END)                                           channel,
               pot.contract                                    order_from,
               pot.vendor_no                                   order_to,
               polt.part_no                                    sku,
               (polt.buy_qty_due - NVL (rr.qty_arrived, 0))    quantity,
               TRUNC (pot.order_date)                          po_date,
               pot.rowstate                                    po_status
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
               AND pot.order_date BETWEEN $P{FROM_DATE} and $P{TO_DATE}+ 0.99999
               AND pot.rowstate NOT IN ('Cancelled', 'Closed')
               AND polt.rowstate NOT IN ('Cancelled', 'Closed')
               AND order_sent = 'SENT'
               AND $X{IN, pot.contract, SHOP}
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
 WHERE quantity > 0