/* Formatted on 3/15/2023 11:41:34 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.customer_order_reservation_tab cort
 WHERE 1 = 1
 AND (   :p_order_no IS NULL OR (UPPER (cort.order_no) = UPPER ( :p_order_no)));
 
--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.customer_order_reservation_arc cor
 WHERE 1 = 1
 AND (   :p_order_no IS NULL OR (UPPER (cor.order_no) = UPPER ( :p_order_no)));
 
--------------------------------------------------------------------------------
SELECT corsl.serial_no
  FROM ifsapp.customer_order_line_tab        colt,
       ifsapp.customer_order_res_serial_lov  corsl
 WHERE     colt.order_no = corsl.order_no
       AND colt.line_no = corsl.line_no
       AND colt.rel_no = corsl.rel_no
       AND colt.line_item_no = corsl.line_item_no
       AND colt.order_no = NVL ( :p_order_no, colt.order_no)
 
--------------------------------------------------------------------------------
--ifsapp.customer_order_reservation_api