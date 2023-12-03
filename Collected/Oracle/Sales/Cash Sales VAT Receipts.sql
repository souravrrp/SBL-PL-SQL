--Cash Sales VAT Receipts
select p.contract,
       d.order_no,       
       p.receipt_no,
       p.receipt_date,       
       p.rowstate head_status,
       p.appr_date,
       p.vat_receipt,
       p.lpr_printed,
       d.pay_no,
       d.pay_line_no,
       d.payment_method,
       d.curr_amount,
       d.lump_sum_trans_date,
       d.voucher_no,
       d.voucher_type,
       d.voucher_date,
       d.user_id,
       d.identity,
       d.ledger_item_series_id,
       d.ledger_item_id,
       d.mixed_payment_id,
       d.bcb_statement_id,
       d.short_name,
       d.rowstate line_status
  from hpnret_co_pay_head_tab p
 inner join hpnret_co_pay_dtl_tab d
    on p.PAY_NO = d.PAY_NO
 where p.lpr_printed is null
   and p.ROWSTATE = 'Printed'
   and d.rowstate = 'Paid'
   and d.curr_amount > 0
   and d.ORDER_NO like '&ORDER_NO'
   /*and trunc(p.receipt_date) between to_date('2016/1/1', 'yyyy/mm/dd') and
       to_date('2016/1/10', 'yyyy/mm/dd')*/
 --order by d.curr_amount desc
