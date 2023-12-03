--HP Sales VAT Receipts
select h.contract,
       h.account_no,
       h.receipt_no,
       h.receipt_date,
       h.identity,
       h.rowstate line_status,
       h.VAT_RECEIPT,
       h.lpr_printed
  from IFSAPP.HPNRET_PAY_RECEIPT_head_tab h
 where substr(h.receipt_no, 4, 3) = '-HF'
   and h.rowstate = 'Printed'
