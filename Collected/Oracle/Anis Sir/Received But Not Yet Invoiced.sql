select aa.order_no,
       aa.line_no,
       aa.release_no,
       aa.receipt_no,
       SUM(aa.transaction_value)
  from ifsapp.receive_not_inv_trn_clr_union aa
 where aa.grn_no in (select t.grn_no
                       from ifsapp.receive_not_inv_trn_clr_union t
                      group by t.grn_no
                     having sum(t.transaction_value) <> 0)
 GROUP BY aa.order_no, aa.line_no, aa.release_no, aa.receipt_no
