--***** Cancelled Collection Receipts
select p.contract,
       ph.account_no,
       (select h.original_acc_no
          from ifsapp.hpnret_hp_head_tab h
         where h.account_no = ph.account_no) original_acc_no,
       p.receipt_no,
       p.amount,
       trunc(p.voucher_date) payment_date,
       p.pay_method,
       p.rowstate
  from IFSAPP.HPNRET_PAY_RECEIPT_TAB p
 inner join IFSAPP.HPNRET_PAY_RECEIPT_HEAD_TAB ph
    on p.receipt_no = ph.receipt_no
 where p.rowstate = 'Cancelled'
   and substr(p.receipt_no, 4, 3) = '-HC'
   and p.voucher_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and to_date('&TO_DATE', 'YYYY/MM/DD')
