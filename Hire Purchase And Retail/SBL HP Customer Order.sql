/* Formatted on 3/7/2023 4:06:28 PM (QP5 v5.381) */
SELECT hcot.*
  FROM hpnret_customer_order_tab          hcot,
       ifsapp.hpnret_cust_order_line_tab  hcolt
 WHERE     1 = 1
       AND hcot.order_no = hcolt.order_no(+)
       --AND order_no = :p_order_no
       AND (   :p_order_no IS NULL
            OR (UPPER (hcot.order_no) = UPPER ( :p_order_no)));



--------------------------------------------------------------------------------

SELECT *
  FROM hpnret_customer_order_tab hcot
 WHERE     1 = 1
       --AND order_no = :p_order_no
       --AND remarks LIKE '%Ex%in%out%'
       AND (   :p_order_no IS NULL
            OR (UPPER (hcot.order_no) = UPPER ( :p_order_no)));



SELECT *
  FROM ifsapp.hpnret_cust_order_line_tab hcolt
 WHERE     1 = 1
       --AND order_no = :p_order_no
       AND (   :p_order_no IS NULL
            OR (UPPER (hcolt.order_no) = UPPER ( :p_order_no)));

SELECT *
  FROM ifsapp.hpnret_customer_order hco
 WHERE     1 = 1
       --AND order_no = :p_order_no
       AND (   :p_order_no IS NULL
            OR (UPPER (hco.order_no) = UPPER ( :p_order_no)));

SELECT *
  FROM ifsapp.hpnret_cust_order_line hcol
 WHERE     1 = 1
       --AND order_no = :p_order_no
       AND (   :p_order_no IS NULL
            OR (UPPER (hcol.order_no) = UPPER ( :p_order_no)));