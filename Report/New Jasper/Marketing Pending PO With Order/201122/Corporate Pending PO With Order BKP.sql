SELECT channel,
       order_number,
       po_no,
       TRUNC (po_date)                po_date,
       order_from                     order_site,
       order_to                       delivery_site,
       sku                            part_no,
       (SELECT product_family
          FROM ifsapp.sbl_jr_product_dtl_info
         WHERE product_code = sku)    product_family,
       po_quantity                    order_quantity,
       receive_quantity               delivery_quantity,
       pending_quantity,
       po_status
  FROM (SELECT pot.order_no
                   po_no,
               (CASE
                    WHEN pot.contract IN ('JWSS',
                                   'SAOS',
                                   'SWSS',
                                   'WSMO',
                                   'WITM',
                                   'SITM',
                                   'SSAM')
                    THEN
                        'WHOLESALE'
                    WHEN pot.contract = 'SCSM'
                    THEN
                        'CORPORATE'
                    WHEN pot.contract = 'SOSM'
                    THEN
                        'ONLINE CHANNEL'
                    WHEN pot.contract IN ('SAPM',
                                   'SESM',
                                   'SHOM',
                                   'SISM',
                                   'SFSM')
                    THEN
                        'STAFF SCRAP AND ACQUISITION'
                    ELSE
                        'RETAIL'
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
               NVL (rr.qty_arrived, 0)
                   receive_quantity,
               (polt.buy_qty_due - NVL (rr.qty_arrived, 0))
                   pending_quantity,
               TRUNC (pot.order_date)
                   po_date,
               pot.rowstate
                   po_status,
               copo.oe_order_no
                   order_number
          FROM ifsapp.purchase_order_tab        pot,
               ifsapp.purchase_order_line_tab   polt,
               ifsapp.customer_order_pur_order  copo,
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
               AND pot.contract = 'SCSM'
               AND $X{IN, pot.vendor_no, WAREHOUSE}
               AND polt.order_no = copo.po_order_no
               AND polt.line_no = copo.po_line_no
               AND polt.release_no = copo.po_rel_no
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
 WHERE pending_quantity > 0