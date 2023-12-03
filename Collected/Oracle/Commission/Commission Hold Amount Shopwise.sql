--Shopwise Commission Hold Amount as on Date
select c.site, sum(c.comm_calc_amount) comm_calc_amount
  from IFSAPP.COMMISSION_VALUE_DETAIL c
 where c.commission_sales_type = 'HP'
   and c.collection_type = 'INST'
   and c.state = 'Initial'
   and trunc(c.calculated_date) <= to_date('&as_on_date', 'YYYY/MM/DD')
 group by c.site
 order by c.site
