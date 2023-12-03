--Positive Collection
select 
    c.*,
    c.contract,
    c.account_no,
    c.original_acc_no,
    c.receipt_no,
    c.amount amount,
    case when c.amount > 0 
        then (select sum(t.comm_calc_amount) from COMMISSION_VALUE_DETAIL t where t.receipt_no = c.receipt_no and t.comm_calc_amount > 0)
      else
        (select sum(t.comm_calc_amount) from COMMISSION_VALUE_DETAIL t where t.receipt_no = c.receipt_no and t.comm_calc_amount < 0)
      end comm_calc_amount,
    c.payment_date,
    (select h.cash_conversion_on_date from hpnret_form249_arrears_tab h where h.acct_no = c.account_no and rownum <= 1) cash_conversion_on_date,
    c.pay_method,
    c.rowstate    
from SBL_COLLECTION_INFO c
where 
  c.payment_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and
  c.contract like '&site'
  

union


--Negative Collection
SELECT
    r.contract,
    r.order_no account_no,
    c.original_acc_no,
    c.receipt_no,
    (-1) * c.amount amount,
    case when c.amount > 0 
        then (select sum(t.comm_calc_amount) from COMMISSION_VALUE_DETAIL t where t.receipt_no = c.receipt_no and t.comm_calc_amount > 0)
      else
        (select sum(t.comm_calc_amount) from COMMISSION_VALUE_DETAIL t where t.receipt_no = c.receipt_no and t.comm_calc_amount < 0)
      end comm_calc_amount,
    --c.payment_date,
    r.date_returned,
    (select h.cash_conversion_on_date from hpnret_form249_arrears_tab h where h.acct_no = c.account_no and rownum <= 1) cash_conversion_on_date,
    c.pay_method,
    c.rowstate            
FROM 
  SBL_RETURN_INFO r,
  SBL_COLLECTION_INFO c
WHERE
  r.order_no = c.account_no and
  r.contract = c.contract and
  r.date_returned between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and
  c.contract like '&site'
