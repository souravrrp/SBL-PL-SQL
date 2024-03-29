--Commission Summary Sales Typewise
select t.commission_sales_type,
       t.collection_type,
       SUM(t.comm_calc_amount) TOTAL_COMM_AMOUNT,
       t.site,
       T.state
  from COMMISSION_VALUE_DETAIL t
 WHERE --t.collection_type = 'INST' --IS NULL --<> 'INST'
   --and t.comm_calc_amount < 0
   and t.commission_sales_type = 'HP'
   AND trunc(t.calculated_date) BETWEEN to_date('&FromDate', 'YYYY/MM/DD') AND
       to_date('&ToDate', 'YYYY/MM/DD')
   and t.state = 'Approved' --Initial
   and t.site = '&shop_code'
   GROUP BY t.commission_sales_type, t.collection_type, T.state, t.site
