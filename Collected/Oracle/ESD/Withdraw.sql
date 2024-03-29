--Month wise sum withdraw
select
  (select e.shop_code from EMP_INFO e where e.emp_id = w.emp_id) shop_code,
  w.emp_id,
  (select e.name from EMP_INFO e where e.emp_id = w.emp_id) emp_name,
  extract(year from w.entry_dt)||'-'||extract(month from w.entry_dt) period,
  nvl(sum(w.amt), 0) w_amt
from WITHDRAW w
where 
  w.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
  --w.emp_id = 20299
group by w.emp_id, extract(year from w.entry_dt)||'-'||extract(month from w.entry_dt)
order by w.emp_id, period


 
          
--date wise sum amount
select
  (select e.shop_code from EMP_INFO e where e.emp_id = w.emp_id) shop_code,
  w.emp_id,
  sum(w.amt) w_amt,
  (select e.name from EMP_INFO e where e.emp_id = w.emp_id) emp_name,
  w.entry_dt
from WITHDRAW w
where 
  w.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
  --w.emp_id = '20287'
group by w.emp_id, w.entry_dt
order by w.emp_id, w.entry_dt
