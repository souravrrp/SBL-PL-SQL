--New True Hire Account Old Collection
--Previous Postive Collections of New True Hire
select c.contract,
       c.account_no,
       --c.original_acc_no,
       c.receipt_no,
       c.amount amount,
       c.payment_date,
       c.pay_method,
       c.rowstate
  from ifsapp.sbl_collection_info_2014 c
 where c.payment_date < to_date('&from_date', 'YYYY/MM/DD')
   and c.contract like '&site'
   and c.account_no in (select h.acct_no from sbl_true_hp_jan_2015 h)

union

--Previous Negative Collection of New True Hire 
SELECT r.contract,
       r.order_no account_no,
       --c.original_acc_no,
       c.receipt_no,
       (-1) * c.amount amount,
       r.date_returned,
       c.pay_method,
       c.rowstate
  FROM ifsapp.sbl_return_info_2014 r, ifsapp.sbl_collection_info_2014 c
 WHERE r.order_no = c.account_no
   and r.contract = c.contract
   and r.date_returned < to_date('&from_date', 'YYYY/MM/DD')
   and c.contract like '&site'
   and r.order_no in (select h.acct_no from sbl_true_hp_jan_2015 h)
