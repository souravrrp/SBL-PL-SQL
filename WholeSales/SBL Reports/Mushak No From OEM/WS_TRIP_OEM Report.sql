/* Formatted on 6/20/2022 3:40:07 PM (QP5 v5.381) */
SELECT                                                              --DISTINCT
       t.order_no,
       --t.line_no,
       --t.rel_no,
       --t.release_no,
       t.trip_no,
       (SELECT cot.customer_no
          FROM customer_order_tab cot
         WHERE cot.order_no = t.order_no)
           customer_no,
       (SELECT ifsapp.customer_info_api.get_name (cot.customer_no)
          FROM customer_order_tab cot
         WHERE cot.order_no = t.order_no)
           customer_name,
       l.part_no,
       l.serial_no,
       ifsapp.serial_oem_conn_api.get_oem_no (l.part_no, l.serial_no)
           oem_no,
       --t.actual_qty_reserved,
       t.vat_receipt_no
  FROM ifsapp.trn_trip_plan_co_line_tab      t,
       ifsapp.customer_order_res_serial_lov  l
 WHERE     1 = 1
       AND t.order_no = l.order_no
       AND t.line_no = l.line_no
       AND t.rel_no = l.rel_no
       AND t.line_item_no = l.line_item_no
       AND TO_CHAR (t.ROWVERSION, 'MM/DD/RRRR') =
           TO_CHAR (SYSDATE, 'MM/DD/RRRR')
       --AND t.order_no = 'BBW-R21072'
       AND EXISTS
               (SELECT 1
                  FROM customer_order_tab cot
                 WHERE     cot.order_no = t.order_no
                       AND cot.customer_no IN ('JWSS',
                                               'SAOS',
                                               'SWSS',
                                               'WSMO',
                                               'WITM',
                                               'SITM',
                                               'SSAM',
                                               'SCSM'))