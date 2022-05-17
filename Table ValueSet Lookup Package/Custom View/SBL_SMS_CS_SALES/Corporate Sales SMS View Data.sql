/* Formatted on 4/10/2022 9:58:07 AM (QP5 v5.381) */
  SELECT v.trip_no,
         v.customer_no
             site_code,
         v.oe_order_no
             order_no,
         v.po_order_no
             po_no,
         v.order_no
             delivery_order_no,
         ifsapp.customer_order_api.get_customer_no (v.oe_order_no)
             customer_no,
         ifsapp.customer_info_api.get_name (
             ifsapp.hpnret_customer_order_api.get_customer_no (v.oe_order_no))
             customer_name,
         (SELECT c.VALUE
            FROM ifsapp.supplier_info_comm_method c
           WHERE     c.supplier_id =
                     ifsapp.customer_order_api.get_customer_no (v.oe_order_no)
                 AND c.method_id_db = 'PHONE')
             phone_no,
         MAX (v.rowversion)
             delivery_date,
         v.vat_receipt_no
    FROM (SELECT t.trip_no,
                 t.release_no,
                 l.customer_no,
                 p.oe_order_no,
                 p.oe_line_no,
                 p.oe_rel_no,
                 p.oe_line_item_no,
                 p.po_order_no,
                 p.po_line_no,
                 p.po_rel_no,
                 t.order_no,
                 t.line_no,
                 t.rel_no,
                 t.line_item_no,
                 l.part_no,
                 t.actual_qty_reserved,
                 t.vat_receipt_no,
                 t.rowversion,
                 ifsapp.trn_trip_plan_api.get_status (t.trip_no, t.release_no)    rowstate
            FROM ifsapp.trn_trip_plan_co_line_tab t
                 INNER JOIN ifsapp.customer_order_line_tab l
                     ON     t.order_no = l.order_no
                        AND t.line_no = l.line_no
                        AND t.rel_no = l.rel_no
                        AND t.line_item_no = l.line_item_no
                 INNER JOIN ifsapp.customer_order_pur_order p
                     ON     l.demand_order_ref1 = p.po_order_no
                        AND l.demand_order_ref2 = p.po_line_no
                        AND l.demand_order_ref3 = p.po_rel_no
           WHERE     ifsapp.trn_trip_plan_api.get_status (t.trip_no,
                                                          t.release_no) IN
                         ('Delivered', 'Closed')
                 AND l.customer_no = 'SCSM') v
   WHERE 1 = 1 AND v.trip_no = '80000'
GROUP BY v.trip_no,
         v.customer_no,
         v.oe_order_no,
         v.po_order_no,
         v.order_no,
         v.vat_receipt_no;