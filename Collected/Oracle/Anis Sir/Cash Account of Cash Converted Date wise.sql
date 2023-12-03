select 
  --* 
  t.order_no,
  trunc(t.wanted_delivery_date) wanted_delivery_date,
  t.cash_conv,
  t.remarks
from Hpnret_Customer_Order_Tab t
where t.wanted_delivery_date between to_date('2014/1/1', 'YYYY/MM/DD') AND to_date('2014/5/31', 'YYYY/MM/DD') and
t.cash_conv = 'TRUE'