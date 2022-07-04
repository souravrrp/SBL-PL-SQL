select 
    c.contract,
    c.account_no,
    c.original_acc_no,
    c.receipt_no,
    c.amount amount,
    c.payment_date,
    c.pay_method,
    c.rowstate    
from ifsapp.SBL_COLLECTION_INFO c
where 
  c.payment_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and to_date('&TO_DATE', 'YYYY/MM/DD') and
  c.contract like '&SITE'

union

SELECT
    r.contract,
    r.order_no account_no,
    c.original_acc_no,
    c.receipt_no,
    (-1) * c.amount amount,
    r.date_returned,
    c.pay_method,
    c.rowstate            
FROM 
  ifsapp.SBL_RETURN_INFO r,
  ifsapp.SBL_COLLECTION_INFO c
WHERE
  r.order_no = c.account_no and
  r.contract = c.contract and
  r.date_returned between to_date('&FROM_DATE', 'YYYY/MM/DD') and to_date('&TO_DATE', 'YYYY/MM/DD') and
  c.contract like '&SITE'