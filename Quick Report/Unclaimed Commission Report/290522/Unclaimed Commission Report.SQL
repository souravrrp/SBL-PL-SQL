select 
    t.site,
    t.claim_id,
    t.order_no,
    t.ord_line_no,
    t.ord_rel_no,
    t.ord_line_item_no,
    trunc(ifsapp.hpnret_hp_head_api.Get_Sales_Date(t.account_no, t.account_rev)) sales_date,
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
    t.commission_receiver,
    t.reverse_reason,
    t.state,
    (select h.cash_conversion_on_date from ifsapp.HPNRET_FORM249_ARREARS_TAB h
      where h.acct_no = t.account_no and h.year = extract (year from h.sales_date) and 
            h.period = extract (month from h.sales_date)) cash_conversion_on_date
from 
  ifsapp.COMMISSION_VALUE_DETAIL t
WHERE
  t.commission_sales_type = 'HP' and
  t.collection_type = 'INST' and
  t.state = 'Initial' and
  t.site like '&site'
order by t.site, t.order_no, t.receipt_no, t.catalog_no