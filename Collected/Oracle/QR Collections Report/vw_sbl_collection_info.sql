create or replace view sbl_collection_info as
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
 where p.rowstate = 'Approved'
   and substr(p.receipt_no, 4, 3) = '-HC';

/*select p.contract,
       (select ph.account_no
          from IFSAPP.HPNRET_PAY_RECEIPT_HEAD_TAB ph
         where ph.receipt_no = p.receipt_no) account_no,
       (select h.original_acc_no
          from hpnret_hp_head_tab h
         where h.account_no =
               (select ph.account_no
                  from HPNRET_PAY_RECEIPT_HEAD_TAB ph
                 where ph.receipt_no = p.receipt_no)) original_acc_no,
       p.receipt_no,
       p.amount,
       trunc(p.voucher_date) payment_date,
       p.pay_method,
       p.rowstate
  from IFSAPP.HPNRET_PAY_RECEIPT_TAB p
 where p.rowstate = 'Approved'
   and substr(p.receipt_no, 4, 3) = '-HC';*/