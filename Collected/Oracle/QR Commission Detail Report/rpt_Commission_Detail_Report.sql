select 
  --c.*
  c.commission_receiver,
  c.site,
  c.commission_sales_type,
  c.collection_type,
  c.agreement_id,
  c.catalog_no,
  c.quantity,
  c.order_price,
  c.invoice_amount,
  c.installment_amount,
  c.comm_calc_amount,
  to_char(trunc(c.calculated_date), 'YYYY/MM/DD') calculated_date,
  c.order_no,
  c.invoice_id,
  c.inv_item_id,
  to_char(trunc(c.approved_date), 'YYYY/MM/DD') approved_date,
  c.approved_amount,
  c.not_approved_amount,
  c.deduction_type,
  c.deduction_reason,
  c.deduction_amount,
  c.claim_id,
  c.entitlement_type,
  c.receipt_no,
  c.note,
  c.reverse_reason,
  substrb(COMMISSION_VALUE_DETAIL_API.Finite_State_Decode__(rowstate),1,253) state
from 
  IFSAPP.commission_value_detail_tab c
where 
  c.calculated_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and 
  c.site like '&shop_code' and
  c.commission_sales_type like '&commission_type' and
  c.order_no like '&order_no' and
  c.catalog_no like '&catalog_no' and
  c.receipt_no like '&receipt_no' --and
  --c.reverse_reason like '&reverse_reason'
order by calculated_date, c.site, c.catalog_no
