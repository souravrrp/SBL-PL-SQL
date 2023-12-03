select 
  (select h.account_no from HPNRET_PAY_RECEIPT_HEAD_TAB h where h.receipt_no = t.receipt_no) account_no,
  t.contract,
  t.RECEIPT_NO,
  t.AMOUNT,
  t.VOUCHER_NO,
  t.VOUCHER_DATE,
  t.DISCOUNT,
  t.ID,
  t.SHORT_NAME
from ifsapp.HPNRET_PAY_RECEIPT_TAB t
where substr(t.RECEIPT_NO,5,2)='HF'
and  trunc(t.VOUCHER_DATE) between to_date('&FromDate','YYYY/MM/DD') and to_date('&ToDate','YYYY/MM/DD')
and t.ROWSTATE = 'Approved'
and t.CONTRACT like '&Site'
