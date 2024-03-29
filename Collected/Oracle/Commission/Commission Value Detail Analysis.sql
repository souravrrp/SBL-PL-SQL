SELECT t.site,t.commission_receiver,/*SUM(*/t.comm_calc_amount/*)*/
     FROM   commission_value_detail t 
     WHERE  t.commission_receiver like '&OldCommReceiver'
     --AND    t.calculated_date >= to_date('01/01/2013','dd/mm/yyyy')
     --AND    t.state = 'Approved'
     --GROUP BY t.site,t.commission_receiver;


select 
    t.*,
    (select * from (select t1.installment_amount 
      from COMMISSION_VALUE_DETAIL t1 
      where 
      t1.transaction_id = t.org_transaction_id and 
      t1.site = t.site and
      t1.catalog_no = t.catalog_no and
      t1.collection_type = 'INST' and
      t1.comm_calc_amount > 0 --and
      /**/) v1 where rownum <= 1 /*order by rownum desc*/) v_installment_amount
from 
  COMMISSION_VALUE_DETAIL t
WHERE
  t.commission_sales_type = 'HP' and
  t.collection_type = 'INST' and
  t.approved_amount < 0 and
  /*t.transaction_id = 4066377 and
  t.reverse_reason = 'CASH CONVERSION'
  T.site = 'RJBB' and
  t.commission_receiver = '&COMMISSION_RECEIVER' AND*/
  trunc(t.calculated_date) BETWEEN to_date('2014/04/01','YYYY/MM/DD') AND to_date('2014/04/28','YYYY/MM/DD')
  --to_date('01/01/2013','dd/mm/yyyy') AND to_date('15/01/2014','dd/mm/yyyy')


select * from
(select 
    t.transaction_id,
    t
    t.site,
    t.commission_sales_type,
    t.collection_type,
    t.catalog_no,
    t.order_price,
    t.invoice_amount,
    t.installment_amount,
    t.comm_calc_amount,
    t.calculated_date,
    t.order_no,
    t.commission_receiver,
    t.approved_date,
    t.approved_amount,
    t.approved_user,
    t.note,
    t.reverse_reason,
    t.org_transaction_id,
    t.reversed,
    t.state
from COMMISSION_VALUE_DETAIL t 
where 
  t.transaction_id = 13859338 and /*6561427, 6641604, 6545960
  --6966615, 6809135, 6720200, 6705551, 6662166, 6736462, 6763103*/
  --t.site = 'FGQB' and
  --t.catalog_no = 'SRTV-SCT-21F1NFTCF' and
  t.collection_type = 'INST' and
  t.comm_calc_amount > 0) v1
where rownum <= 1
order by rownum desc
