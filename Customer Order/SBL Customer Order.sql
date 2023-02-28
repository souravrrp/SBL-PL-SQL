/* Formatted on 4/7/2022 9:14:49 AM (QP5 v5.381) */
SELECT cot.order_no, cot.date_entered sales_date
  ,cot.*
  --,colt.*
  FROM ifsapp.customer_order_tab cot, ifsapp.customer_order_line_tab colt
 WHERE     1 = 1
       AND cot.order_no = colt.order_no
       and (:p_customer_no is null or (cot.customer_no = :p_customer_no))
       --and cot.customer_no='W0002991-2'
       --AND cot.order_no like ('%SIS-R4991%')
       and (:p_order_no is null or (cot.order_no = :p_order_no))
       ;

--------------------------------*********************---------------------------

SELECT *
  FROM customer_order_tab cot
 WHERE 1 = 1 AND cot.order_no = 'KTA-H8297';

SELECT *
  FROM ifsapp.customer_order_line_tab colt
 WHERE 1 = 1 AND colt.order_no = 'KTA-H8296';

--------------------------------*********************---------------------------

SELECT * FROM ifsapp.customer_order;

SELECT *
  FROM ifsapp.customer_order_line col
 WHERE 1 = 1 AND col.order_no = 'KTA-H8297';