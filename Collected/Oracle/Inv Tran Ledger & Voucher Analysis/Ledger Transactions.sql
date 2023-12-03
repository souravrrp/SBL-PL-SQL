--Ledger Transactions
SELECT r.voucher_no,
       SUM(r.currency_debet_amount),
       SUM(r.currency_credit_amount)
  FROM gl_and_hold_vou_row_qry r
 WHERE r.account = '10110055'
   AND r.accounting_year = '&year'
   AND r.accounting_period = '&period'
 GROUP BY r.voucher_no
 ORDER BY r.voucher_no;
