--Collection Commission Summary
select c.site,
       c.commission_sales_type,
       c.collection_type,
       /*c.approved_date,*/
       sum(c.approved_amount) approved_amount,
       c.state
  from IFSAPP.COMMISSION_VALUE_DETAIL c
 where c.state = 'Approved' /*like '&state'*/ --Initial for Commission Holds
      /*and c.site like '&shop_code'*/
      /*and c.commission_sales_type = 'HP'*/
   and c.collection_type /*is null*/
       = 'INST'
      /*and trunc(c.calculated_date) <= to_date('&as_on_date', 'YYYY/MM/DD')*/
      /*and (c.catalog_no like 'SRSM-%' or c.catalog_no like '%FUR-%')*/
   and c.approved_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 group by c.site, c.commission_sales_type, c.collection_type, c.state
 order by c.site, c.commission_sales_type, c.collection_type, c.state
