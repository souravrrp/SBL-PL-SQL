select 
    t.site,
    t.commission_type,
    t.commission_sales_type,
    t.collection_type,
    t.catalog_no,
    t.quantity,
    t.order_price,
    t.invoice_amount,
    t.installment_amount,
    0 org_installment_amount,
    t.comm_calc_amount,
    to_char(trunc(t.calculated_date), 'YYYY/MM/DD') calculated_date,
    t.order_no,
    to_char(t.approved_date, 'YYYY/MM/DD') approved_date,
    t.approved_amount,
    t.not_approved_amount,
    t.approved_user,
    t.reversed,
    t.state
from 
  IFSAPP.COMMISSION_VALUE_DETAIL t
where 
  t.state <> 'Approved' and
  t.site like '&shop_code'
