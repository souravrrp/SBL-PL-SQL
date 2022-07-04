/* Formatted on 6/26/2022 2:57:37 PM (QP5 v5.381) */
  SELECT t.supplier_no,
         t.order_no,
         t.grn_no,
         t.line_no,
         t.release_no,
         t.receipt_no,
         SUM (t.grn_qty),
         SUM (t.transaction_value)
    FROM ifsapp.receive_not_inv_transfer t
GROUP BY t.supplier_no,
         t.order_no,
         t.grn_no,
         t.line_no,
         t.release_no,
         t.receipt_no
  HAVING SUM (t.transaction_value) <> 0