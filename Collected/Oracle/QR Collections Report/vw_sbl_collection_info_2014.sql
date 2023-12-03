create or replace view sbl_collection_info_2014 as
  select
      p.contract,
      (select ph.account_no from HPNRET_PAY_RECEIPT_HEAD_TAB ph where ph.receipt_no = p.receipt_no) account_no,
      (select h.original_acc_no from hpnret_hp_head_tab h
        where h.account_no = (select ph.account_no from HPNRET_PAY_RECEIPT_HEAD_TAB ph
                                where ph.receipt_no = p.receipt_no)) original_acc_no,
      p.receipt_no,
      p.amount,
      trunc(p.voucher_date) payment_date,
      p.pay_method,
      p.rowstate
  from HPNRET_PAY_RECEIPT_TAB p
  where
    p.rowstate = 'Approved' and
    p.voucher_date between to_date('2014/1/1', 'YYYY/MM/DD') and to_date('2014/12/31', 'YYYY/MM/DD') and
    substr(p.receipt_no, 4, 3) = '-HC';
