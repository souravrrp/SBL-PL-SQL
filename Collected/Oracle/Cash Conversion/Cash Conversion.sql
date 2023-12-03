select
    h.order_no,
    p.curr_amount*(-1) curr_amount,
    to_char(h.WANTED_DELIVERY_DATE, 'YYYY/MM/DD') WANTED_DELIVERY_DATE
from
  hpnret_customer_order h,
  hpnret_co_pay_dtl_tab p
where 
  h.order_no=p.order_no and 
  h.CASH_CONV='TRUE'  AND   
  TRUNC(h.WANTED_DELIVERY_DATE) BETWEEN TO_DATE('&from_date','YYYY/MM/DD') AND TO_DATE('&to_date','YYYY/MM/DD')
