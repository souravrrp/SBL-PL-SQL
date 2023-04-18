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
       AND ( cot.order_no = $P{ORDER_NO} or  $P{ORDER_NO} IS NULL)
       AND cot.date_entered BETWEEN $P{FROM_DATE}  and $P{TO_DATE}