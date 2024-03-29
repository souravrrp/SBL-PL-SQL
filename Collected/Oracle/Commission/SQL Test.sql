select t.transaction_id,
    t.trans_item_no,
    t.trans_revision_no,
    t.commission_receiver,
    t.site,
    t.channel_id,
    t.customer_type, 
    t.entitlement_type,
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
    t.comm_calc_amount 
from COMMISSION_VALUE_DETAIL_TAB t
group by t.customer_type, t.entitlement_type


select * from 
(select count(*) from COMMISSION_VALUE_DETAIL_TAB t
where exists (select distinct t.customer_type, 
    --t.commission_receiver,
    t.entitlement_type, 
    t.commission_type, 
    t.commission_sales_type, 
    t.agreement_id 
from COMMISSION_VALUE_DETAIL_TAB t)) t1
where rownum <= 5
order by rownum desc


/*t.customer_type \*in ('ALL','EMPLOYEE', 'GROUP', 'INSTITUTE', 'NORMAL') and*\ is null
  t.entitlement_type in (select distinct(t.entitlement_type) from COMMISSION_VALUE_DETAIL_TAB t)*/

select count(*) from COMMISSION_VALUE_DETAIL_TAB t
where --t.customer_type in ('ALL','EMPLOYEE', 'GROUP', 'INSTITUTE', 'NORMAL', '') and --is null
  --t.entitlement_type in (select distinct(t.entitlement_type) from COMMISSION_VALUE_DETAIL_TAB t) and
  --t.commission_type in (select distinct(t.commission_type) from COMMISSION_VALUE_DETAIL_TAB t) and
  --t.commission_sales_type in (select distinct(t.commission_sales_type) from COMMISSION_VALUE_DETAIL_TAB t) and
  --t.reversed in (select distinct(t.reversed) from COMMISSION_VALUE_DETAIL_TAB t) and
  t.agreement_id /*not in (select distinct(t.agreement_id) from COMMISSION_VALUE_DETAIL_TAB t)*/ is null
  
select count(t.customer_type), count(t.entitlement_type) from COMMISSION_VALUE_DETAIL_TAB t


select distinct t.customer_type, 
    --t.commission_receiver,
    t.entitlement_type, 
    t.commission_type, 
    t.commission_sales_type, 
    t.agreement_id 
from COMMISSION_VALUE_DETAIL_TAB t

select distinct(t.customer_type) from COMMISSION_VALUE_DETAIL_TAB t)

select distinct(t.entitlement_type) from COMMISSION_VALUE_DETAIL_TAB t

select distinct(t.commission_type) from COMMISSION_VALUE_DETAIL_TAB t

select distinct(t.commission_sales_type) from COMMISSION_VALUE_DETAIL_TAB t

select distinct(t.reversed) from COMMISSION_VALUE_DETAIL_TAB t

select distinct(t.agreement_id) from COMMISSION_VALUE_DETAIL_TAB t
