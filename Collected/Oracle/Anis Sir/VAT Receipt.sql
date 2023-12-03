--Cash Sale VAT Receipt
select
   *
   --p.VAT_RECEIPT 
from
  hpnret_co_pay_head_tab p ,
  hpnret_co_pay_dtl_tab d
where
  p.PAY_NO = d.PAY_NO and 
  --d.ORDER_NO= c.order_no and 
  d.PAY_LINE_NO=1 and 
  p.ROWSTATE in ('Approved', 'Printed') and 
  trunc(p.rowversion) between to_date('2015/1/1', 'YYYY/MM/DD') and to_date('2015/1/10', 'YYYY/MM/DD')
  --p.VAT_RECEIPT is not null and
  --ROWNUM <= 1

--*****
select p.vat_receipt from hpnret_co_pay_head_tab p
where 
  p.pay_no = (select d.pay_no from hpnret_co_pay_dtl_tab d 
    where d.order_no = 'HNJ-R2896' and d.pay_line_no = 1 and d.rowstate = 'Paid') and
  p.rowstate in ('Approved', 'Printed')

  

--Hire Sale VAT Receipt
select 
    distinct h.VAT_RECEIPT
from 
  IFSAPP.HPNRET_PAY_RECEIPT_head_tab h 
where 
  h.ACCOUNT_NO=t.ORDER_NO and 
  h.VAT_RECEIPT is not null and 
  ROWNUM <= 1
  

hpnret_co_pay_head_api.Get_Vat_Receipt
