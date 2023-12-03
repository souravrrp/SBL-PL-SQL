--Collections with Manual Receipt No
select p.contract,
       (select ph.account_no
          from HPNRET_PAY_RECEIPT_HEAD_TAB ph
         where ph.receipt_no = p.receipt_no) account_no,
       (select h.original_acc_no
          from hpnret_hp_head_tab h
         where h.account_no =
               (select ph.account_no
                  from HPNRET_PAY_RECEIPT_HEAD_TAB ph
                 where ph.receipt_no = p.receipt_no)) original_acc_no,
       p.receipt_no,
       (select ph.Sheet_Serial_No
          from HPNRET_PAY_RECEIPT_HEAD_TAB ph
         where ph.receipt_no = p.receipt_no) manual_receipt_no,
       p.amount,
       trunc(p.voucher_date) payment_date,
       p.pay_method,
       p.rowstate
  from HPNRET_PAY_RECEIPT_TAB p
 where p.rowstate = 'Approved'
   and substr(p.receipt_no, 4, 3) = '-HC'
   /*and p.contract = 'AKPB'*/
   and (select ph.Sheet_Serial_No
          from HPNRET_PAY_RECEIPT_HEAD_TAB ph
         where ph.receipt_no = p.receipt_no) is not null
   and p.voucher_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
