/* Formatted on 6/20/2022 4:52:14 PM (QP5 v5.381) */
SELECT t.order_no,
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
       t.vat_receipt_no
  FROM ifsapp.trn_trip_plan_co_line_tab      t,
       ifsapp.customer_order_res_serial_lov  l
 WHERE     1 = 1
       AND t.order_no = l.order_no
       AND t.line_no = l.line_no
       AND t.rel_no = l.rel_no
       AND t.line_item_no = l.line_item_no
       AND EXISTS
               (SELECT 1
                  FROM SERIAL_OEM_CONN_TAB soct
                 WHERE soct.part_no = l.part_no AND soct.serial_no = l.serial_no
                 AND $X{IN, pot.contract, OEM_NO})
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