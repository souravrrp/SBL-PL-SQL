select 
    *
    --count(*)
    /*t.commission_receiver,
    t.site,
    t.commission_sales_type,
    t.collection_type,
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
    to_char(trunc(t.approved_date), 'YYYY/MM/DD') approved_date,
    t.order_no,
    t.account_no,
    t.receipt_no,
    t.reverse_reason,
    T.state*/
from 
  COMMISSION_VALUE_DETAIL t
WHERE
  t.commission_sales_type = 'HP' and
  t.collection_type = 'INST' and
 -- t.approved_amount < 0 and
  t.site like '&Site' and
  /*t.account_no IN 
    (SELECT DISTINCT t.account_no 
      FROM hpnret_hp_dtl_tab t 
      WHERE 
        trunc(t.variated_date) BETWEEN to_date('&FromDate','yyyy/mm/dd') AND to_date('&ToDate','yyyy/mm/dd') AND 
        t.contract like '&Site' AND 
        t.rowstate in ('CashConverted', 'ExchangedIn', 'Returned')) AND*/
  --t.commission_receiver like '&Salesman' and
  --t.order_no = 'DUT-H5509' and
  --t.receipt_no = '&receipt_no' and
  --trunc(t.calculated_date) BETWEEN to_date('&FromDate','YYYY/MM/DD') AND to_date('&ToDate','YYYY/MM/DD') --and
  t.approved_date BETWEEN to_date('&FromDate','YYYY/MM/DD') AND to_date('&ToDate','YYYY/MM/DD')
  --t.approved_date BETWEEN to_date('&FromDate','YYYY/MM/DD') AND to_date('&ToDate','YYYY/MM/DD') and
  --t.transaction_id ='7156415' and
  --t.state = 'Approved'
