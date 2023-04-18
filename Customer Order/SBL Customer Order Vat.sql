/* Formatted on 4/5/2023 3:04:03 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.cust_order_line_tax_lines_tab  coltlt
 WHERE     1 = 1
       AND ( :p_order_no IS NULL OR (coltlt.order_no = :p_order_no));
       
       SELECT sft.fee_rate
  FROM ifsapp.statutory_fee_tab sft;