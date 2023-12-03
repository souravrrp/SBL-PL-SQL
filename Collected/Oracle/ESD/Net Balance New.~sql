--Employee wise opening balance
select 
    v.emp_id,
    v.shop_code,
    (select e.name from EMP_INFO e where e.emp_id = v.emp_id) emp_name,
    --extract(year from v.entry_dt)||'-'||extract(month from v.entry_dt) period,
    'Opening Balance' period,
    sum(v.amt) amt
from v_Monthly_Transaction v
where 
  v.entry_dt < trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') and
  v.emp_id in (select e.emp_id from EMP_INFO e where e.type = '&emp_type')
group by v.emp_id, v.shop_code --, extract(year from v.entry_dt)||'-'||extract(month from v.entry_dt)
--order by v.emp_id

union

--Monthly employee wise net balance
select 
    v.emp_id,
    v.shop_code,
    (select e.name from EMP_INFO e where e.emp_id = v.emp_id) emp_name,
    extract(year from v.entry_dt)||'-'||extract(month from v.entry_dt) period,
    sum(v.amt) amt
from v_Monthly_Transaction v
where 
  v.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
      and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) and
  v.emp_id in (select e.emp_id from EMP_INFO e where e.type = '&emp_type')
group by v.emp_id, v.shop_code, extract(year from v.entry_dt)||'-'||extract(month from v.entry_dt)
--order by v.emp_id
