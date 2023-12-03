--Month wise sum deposit
select
  (select e.shop_code from EMP_INFO e where e.emp_id = d.emp_id) shop_code,
  d.emp_id,
  (select e.name from EMP_INFO e where e.emp_id = d.emp_id) emp_name,
  extract(year from d.entry_dt) year,/*||'-'||*/
  extract(month from d.entry_dt) period,
  nvl(sum(d.amt), 0) d_amt
from DEPOSIT d
where 
  d.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
  --d.emp_id = 20001
group by d.emp_id, extract(year from d.entry_dt),/*||'-'||*/extract(month from d.entry_dt)
order by shop_code, d.emp_id, year, period


--date wise sum amount
select
  (select e.shop_code from EMP_INFO e where e.emp_id = d.emp_id) shop_code,
  d.emp_id,
  (select e.name from EMP_INFO e where e.emp_id = d.emp_id) emp_name,
  nvl(sum(d.amt), 0) d_amt,  
  d.entry_dt
from DEPOSIT d
where 
  d.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
  --d.emp_id = '20459'
group by d.emp_id, d.entry_dt
order by shop_code, d.emp_id, d.entry_dt 
          
