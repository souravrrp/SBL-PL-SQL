select 
    t.site,
    t.claim_id,
    t.order_no,
    t.ord_line_no,
    t.ord_rel_no,
    t.ord_line_item_no,
    t.receipt_no,
    t.commission_sales_type,
    t.collection_type,
    t.catalog_no,
    t.installment_amount,
    (select t1.installment_amount 
      from ifsapp.COMMISSION_VALUE_DETAIL t1 
      where 
        t1.transaction_id = t.org_transaction_id and 
        t1.site = t.site and
        t1.catalog_no = t.catalog_no and
        t1.collection_type = 'INST' and
        t1.comm_calc_amount > 0 and
        rownum <= 1) org_installment_amount,
    t.comm_calc_amount,
    to_char(trunc(t.calculated_date), 'YYYY/MM/DD') collected_date,
    c.calculated_date commission_calculated_date,
    t.commission_receiver,
    t.reverse_reason,
    t.state
from 
  ifsapp.COMMISSION_VALUE_DETAIL t,
  ifsapp.COMM_BONS_INCEN_CLAIM c
WHERE
  t.claim_id = c.claim_id and
  t.site = c.site and
  t.commission_sales_type = 'HP' and
  t.collection_type = 'INST' and
  t.claim_id is not null and
  t.state = 'Approved' and
  t.site like '&site' and
  c.calculated_date BETWEEN to_date('&start_date','YYYY/MM/DD') AND to_date('&end_date','YYYY/MM/DD')
order by t.site, t.order_no, t.receipt_no, t.catalog_no
