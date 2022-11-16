/* Formatted on 6/7/2022 3:38:25 PM (QP5 v5.381) */
SELECT pot.order_no              po_no,
       (CASE
            WHEN SUBSTR (pot.order_no, 0, 2) = 'A-' THEN 'Retail'
            WHEN SUBSTR (pot.order_no, 0, 2) = 'W-' THEN 'Wholease'
            WHEN SUBSTR (pot.order_no, 0, 2) = 'I-' THEN 'Corp'
            WHEN SUBSTR (pot.order_no, 0, 2) = 'O-' THEN 'Online'
            ELSE 'Others'
        END)                     channel,
       pot.contract              order_from,
       pot.vendor_no             order_to,
       polt.part_no              sku,
       polt.buy_qty_due          quantity,
       TRUNC (pot.order_date)    po_date,
       pot.rowstate              po_status
  FROM ifsapp.purchase_order_tab pot, ifsapp.purchase_order_line_tab polt
 WHERE     1 = 1
       AND pot.order_no = polt.order_no
       AND pot.order_date BETWEEN TO_DATE ('&from_date', 'YYYY/MM/DD')
                              AND TO_DATE ('&to_date', 'YYYY/MM/DD')+0.99999
       AND pot.rowstate NOT IN ('Cancelled', 'Closed')
       AND polt.rowstate NOT IN ('Cancelled', 'Closed')
       AND ORDER_SENT = 'SENT'
       AND EXISTS
               (SELECT 1
                  FROM ifsapp.customer_order co
                 WHERE     1 = 1
                       AND co.customer_po_no = pot.order_no
                       AND co.state NOT IN
                               ('Cancelled', 'Closed', 'Invoiced/Closed'));