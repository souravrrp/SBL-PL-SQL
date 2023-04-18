/* Formatted on 3/29/2023 2:13:44 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.bcb_statement_tab bst
 WHERE     1 = 1
       AND (   :p_statement_no IS NULL
            OR (UPPER (bst.bcb_statement_no) = UPPER ( :p_statement_no)));

SELECT *
  FROM ifsapp.bcb_statement_details_tab bsdt
 WHERE 1 = 1 AND bsdt.bcb_statement_id = 144;

SELECT *
  FROM ifsapp.bcb_statement_bank_detail_tab bsbdt
 WHERE 1 = 1 AND bsbdt.bcb_statement_id = 144;

--------------------------------------------------------------------------------
