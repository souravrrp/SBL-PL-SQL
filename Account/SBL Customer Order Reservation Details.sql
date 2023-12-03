/* Formatted on 4/3/2023 1:39:14 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.customer_order_reservation_tab cort
 WHERE     1 = 1
       AND cort.serial_no = NVL ( :p_serial_no, cort.serial_no)
       AND (   :p_order_no IS NULL
            OR (UPPER (cort.order_no) = UPPER ( :p_order_no)));


SELECT hsrlt.sales_return_no, hsrlt.serial_no
  FROM ifsapp.hpnret_sales_ret_line_tab hsrlt
 WHERE     1 = 1
       AND hsrlt.serial_no = NVL ( :p_serial_no, hsrlt.serial_no)
       --AND hsrlt.serial_no = '35552'
       --AND hsrlt.order_no = 'CDG-R7285'
       AND hsrlt.order_no = NVL ( :p_order_no, hsrlt.order_no);


