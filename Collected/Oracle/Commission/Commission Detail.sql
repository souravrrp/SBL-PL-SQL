--Positive commission amounts
select 
    --t.*,
    /*t.transaction_id,
    t.trans_item_no,
    t.trans_revision_no,
    t.commission_receiver,
    t.site,
    t.channel_id,
    t.customer_type,
    t.commission_type,
    t.commission_sales_type,
    t.collection_type,
    t.commission_path,
    t.condition_code,
    t.agreement_id,
    t.revision_no,
    t.rev_line_no,
    t.catalog_no,
    t.quantity,
    t.order_price,
    t.invoice_amount,
    t.installment_amount,
    0 org_installment_amount,*/
    t.comm_calc_amount,
    to_char(trunc(t.calculated_date), 'YYYY/MM/DD') calculated_date,
    t.order_no,
    t.ord_line_no,
    t.ord_rel_no,
    t.ord_line_item_no,
    t.invoice_id,
    t.inv_item_id,
    t.account_no,
    t.account_rev,
    t.acc_line_no,
    to_char(t.approved_date, 'YYYY/MM/DD') approved_date,
    t.approved_amount,
    t.not_approved_amount,
    t.approved_user,
    t.deduction_type,
    t.deduction_reason,
    t.deduction_amount,
    t.credit_note_no,
    t.claim_id,
    t.deduct_from_comm_receiver,
    t.deduction_rule_id,
    t.deduction_rule_line_no,
    t.allow_enter_values,
    t.changed_flag,
    t.entitlement_type,
    t.receipt_no,
    t.charge_type,
    t.company,
    t.invoice_no,
    t.location_no,
    t.note,
    t.advance_pay_no,
    t.enter_from_client,
    t.reverse_reason,
    t.org_transaction_id,
    t.org_trans_item_no,
    t.org_trans_revision_no,
    t.reversed,
    t.objid,
    t.objversion,
    t.objstate,
    t.objevents,
    t.state
from 
  COMMISSION_VALUE_DETAIL t
WHERE
  t.commission_sales_type = 'HP' and
  t.collection_type = 'INST' and --to include DP
  t.approved_amount > 0 and
  --t.order_no = 'RGS-H1678' and
  trunc(t.calculated_date) BETWEEN to_date('&start_date','YYYY/MM/DD') AND to_date('&end_date','YYYY/MM/DD')


union all


--Negative commission amounts
select 
    --t.*,
    t.transaction_id,
    t.trans_item_no,
    t.trans_revision_no,
    t.commission_receiver,
    t.site,
    t.channel_id,
    t.customer_type,
    t.commission_type,
    t.commission_sales_type,
    t.collection_type,
    t.commission_path,
    t.condition_code,
    t.agreement_id,
    t.revision_no,
    t.rev_line_no,
    t.catalog_no,
    t.quantity,
    t.order_price,
    t.invoice_amount,
    t.installment_amount,
    (select t1.installment_amount 
      from COMMISSION_VALUE_DETAIL t1 
      where 
      t1.transaction_id = t.org_transaction_id and 
      t1.site = t.site and
      t1.catalog_no = t.catalog_no and
      t1.collection_type = 'INST' and
      t1.comm_calc_amount > 0 and
      rownum <= 1) org_installment_amount,
    t.comm_calc_amount,
    to_char(trunc(t.calculated_date), 'YYYY/MM/DD') calculated_date,
    t.order_no,
    t.ord_line_no,
    t.ord_rel_no,
    t.ord_line_item_no,
    t.invoice_id,
    t.inv_item_id,
    t.account_no,
    t.account_rev,
    t.acc_line_no,
    to_char(t.approved_date, 'YYYY/MM/DD') approved_date,
    t.approved_amount,
    t.not_approved_amount,
    t.approved_user,
    t.deduction_type,
    t.deduction_reason,
    t.deduction_amount,
    t.credit_note_no,
    t.claim_id,
    t.deduct_from_comm_receiver,
    t.deduction_rule_id,
    t.deduction_rule_line_no,
    t.allow_enter_values,
    t.changed_flag,
    t.entitlement_type,
    t.receipt_no,
    t.charge_type,
    t.company,
    t.invoice_no,
    t.location_no,
    t.note,
    t.advance_pay_no,
    t.enter_from_client,
    t.reverse_reason,
    t.org_transaction_id,
    t.org_trans_item_no,
    t.org_trans_revision_no,
    t.reversed,
    t.objid,
    t.objversion,
    t.objstate,
    t.objevents,
    t.state
from 
  COMMISSION_VALUE_DETAIL t
WHERE
  t.commission_sales_type = 'HP' and
  t.collection_type = 'INST' and
  t.approved_amount < 0 and
  --t.order_no = 'RGS-H1678' and
  trunc(t.calculated_date) BETWEEN to_date('&start_date','YYYY/MM/DD') AND to_date('&end_date','YYYY/MM/DD')

--order by site, commission_receiver, order_no, catalog_no, calculated_date, 
