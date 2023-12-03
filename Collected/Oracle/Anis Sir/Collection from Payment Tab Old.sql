--Positive Collection
select 
    p.contract,
    (select ph.account_no from HPNRET_PAY_RECEIPT_HEAD_TAB ph where ph.receipt_no = p.receipt_no) account_no,
    (select h.original_acc_no from hpnret_hp_head_tab h 
      where h.account_no = (select ph.account_no 
                              from HPNRET_PAY_RECEIPT_HEAD_TAB ph where ph.receipt_no = p.receipt_no)) original_acc_no,
    p.receipt_no,
    p.amount,
    trunc(p.voucher_date) payment_date,
    p.pay_method,
    p.rowstate 
from HPNRET_PAY_RECEIPT_TAB p
where 
  trunc(p.voucher_date) between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and
  p.contract like '&site' and
  substr(p.receipt_no, 4, 3) = '-HC' and
  p.rowstate = 'Approved'

union

--Negative Collection
select
    v.contract,
    v.account_no,
    v.original_acc_no,
    v.receipt_no,
    (-1) * v.amount amount,
    v.payment_date,
    v.pay_method,
    v.rowstate
from
  (select 
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
  from HPNRET_PAY_RECEIPT_TAB p where p.rowstate = 'Approved') v
where
  v.account_no in (select r.order_no from RETURN_MATERIAL_LINE_TAB r
    where 
      trunc(r.date_returned) between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and
      r.contract like '&site' and
      substr(r.order_no, 4, 2) = '-H' and
      r.order_no in (select h.account_no from hpnret_hp_dtl_tab h 
        where h.account_no = r.order_no and h.ref_line_no = r.line_no and h.ref_rel_no = r.rel_no 
          and h.ref_line_item_no = r.line_item_no and h.catalog_no = r.catalog_no and h.reverted_date is null)
    group by r.order_no) and
  v.contract like '&site' and
  substr(v.receipt_no, 4, 3) = '-HC'
