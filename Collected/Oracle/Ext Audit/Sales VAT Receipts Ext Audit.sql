--*****Sales VAT Receipts Ext Audit
--HP Sales VAT Receipts
select h.contract,
       h.account_no,
       h.receipt_no,
       trunc(h.receipt_date) receipt_date,
       h.rowstate status,
       h.VAT_RECEIPT
  from IFSAPP.HPNRET_PAY_RECEIPT_head_tab h
 where substr(h.receipt_no, 4, 3) = '-HF'
   and h.rowstate = 'Printed'
   and trunc(h.receipt_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')

union all

--Cash Sales VAT Receipts
select p.contract,
       d.order_no,
       p.receipt_no,
       trunc(p.receipt_date) receipt_date,
       p.rowstate status,
       p.vat_receipt
  from hpnret_co_pay_head_tab p
 inner join hpnret_co_pay_dtl_tab d
    on p.PAY_NO = d.PAY_NO
 where p.lpr_printed is null
   and p.ROWSTATE = 'Printed'
   and d.rowstate = 'Paid'
   and d.curr_amount > 0
   and trunc(p.receipt_date) between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
 order by 2
