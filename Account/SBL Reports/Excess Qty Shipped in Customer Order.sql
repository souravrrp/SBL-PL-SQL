/* Formatted on 3/20/2023 11:18:58 AM (QP5 v5.381) */
SELECT cot.CONTRACT                                            site,
       cot.order_no,
       cot.date_entered                                        sales_date,
       colt.customer_no,
       ifsapp.customer_info_api.get_name (colt.customer_no)    customer_name,
       colt.catalog_no                                         part_no,
       cort.serial_no,
       colt.buy_qty_due                                        qty
  FROM ifsapp.customer_order_tab              cot,
       ifsapp.customer_order_line_tab         colt,
       ifsapp.customer_order_reservation_tab  cort
 WHERE     1 = 1
       AND cot.order_no = colt.order_no
       AND colt.contract = cort.contract(+)
       AND colt.order_no = cort.order_no(+)
       AND colt.part_no = cort.part_no(+)
       AND colt.qty_shipdiff IN (1, 2, 3)
       --and cot.customer_no='W0002991-2'
       --AND cot.order_no like ('%SIS-R4991%')
       AND ( :p_order_no IS NULL OR (cot.order_no = :p_order_no))
       AND TRUNC (cot.date_entered) BETWEEN NVL ( :p_date_from,
                                                 TRUNC (cot.date_entered))
                                        AND NVL ( :p_date_to,
                                                 TRUNC (cot.date_entered));