/* Formatted on 3/29/2023 2:16:18 PM (QP5 v5.381) */
SELECT bst.bcb_statement_no
  --,bst.*
  --,bsdt.*
  --bsbdt.*
  FROM ifsapp.bcb_statement_tab              bst,
       ifsapp.bcb_statement_details_tab      bsdt,
       ifsapp.bcb_statement_bank_detail_tab  bsbdt
 WHERE     1 = 1
       AND bst.bcb_statement_id = bsdt.bcb_statement_id(+)
       AND bst.bcb_statement_id = bsbdt.bcb_statement_id(+)
       AND (   :p_statement_no IS NULL
            OR (UPPER (bst.bcb_statement_no) = UPPER ( :p_statement_no)));