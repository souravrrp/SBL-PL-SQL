--Monthly Positive Calculated Commission Amount Sum
select 
    extract(year from t.calculated_date)||'-'||extract(month from t.calculated_date) period,
    SUM(t.comm_calc_amount) comm_calc_amount--,
    --to_char(trunc(t.calculated_date), 'YYYY/MM/DD') calculated_date--,
from 
  COMMISSION_VALUE_DETAIL t
WHERE
  t.commission_sales_type = 'CASH' and --CASH, HP
  --t.collection_type is null /*= 'INST'*/ and
  t.approved_amount > 0 and
  trunc(t.calculated_date) BETWEEN to_date('&start_date','YYYY/MM/DD') AND to_date('&end_date','YYYY/MM/DD') --AND
  --T.state = 'Approved'
GROUP BY
  extract(year from t.calculated_date)||'-'||extract(month from t.calculated_date)

union


--Monthly Negative Calculated Commission Amount Sum
select 
    extract(year from t.calculated_date)||'-'||extract(month from t.calculated_date) period,
    sum(t.comm_calc_amount) comm_calc_amount--,
    --to_char(trunc(t.calculated_date), 'YYYY/MM/DD') calculated_date
from 
  COMMISSION_VALUE_DETAIL t
WHERE
  t.commission_sales_type = 'CASH' and --CASH, HP
  --t.collection_type is null  /*= 'INST'*/ and
  t.approved_amount < 0 and
  trunc(t.calculated_date) BETWEEN to_date('&start_date','YYYY/MM/DD') AND to_date('&end_date','YYYY/MM/DD') --AND
  --T.state = 'Approved'
GROUP BY
  extract(year from t.calculated_date)||'-'||extract(month from t.calculated_date)
