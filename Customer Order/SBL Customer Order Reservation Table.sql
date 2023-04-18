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
--ifsapp.customer_order_reservation_api