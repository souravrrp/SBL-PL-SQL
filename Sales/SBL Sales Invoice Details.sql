/* Formatted on 3/6/2023 10:53:56 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.sbl_jr_sales_dtl_inv sjsdi
 WHERE     1 = 1
       -- and invoice_id is null
       AND (   :p_order_no IS NULL
            OR (UPPER (sjsdi.order_no) = UPPER ( :p_order_no)));