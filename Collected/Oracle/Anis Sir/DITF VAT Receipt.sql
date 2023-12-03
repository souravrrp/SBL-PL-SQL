select
    --*
    p.pay_no,
    d.order_no,
    p.vat_receipt--,
    --p.receipt_date,
    --p.rowversion,
    --p.rowstate    
from 
  hpnret_co_pay_head_tab p,
  hpnret_co_pay_dtl_tab d
where 
  p.PAY_NO = d.PAY_NO and 
  --d.ORDER_NO= c.order_no and 
  P.contract = 'DITF' AND
  TRUNC(P.ROWVERSION) = TO_DATE('&sale_date', 'YYYY/MM/DD') AND
  --TRUNC(P.ROWVERSION) between TO_DATE('&from_date', 'YYYY/MM/DD') AND TO_DATE('&to_date', 'YYYY/MM/DD') AND
  P.ROWSTATE = 'Printed'