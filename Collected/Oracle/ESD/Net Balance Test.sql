select
    e.emp_id,
    e.name,
    e.shop_code,
    d.year,
    d.period,
    nvl(d.d_amt, 0) d_amt,
    nvl(w_amt, 0) w_amt,
    nvl(d.d_amt, 0) - nvl(w.w_amt, 0) net_balance
from 
  EMP_INFO e 
    left join
    
    --Monthly employee wise deposit
  (select
    d.emp_id,
    d.entry_dt,
    extract(year from d.entry_dt) year,
    extract(month from d.entry_dt) period,
    sum(d.amt) d_amt
  from DEPOSIT d
  where 
    d.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
      and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
    --d.emp_id = 20001
  group by d.emp_id, d.entry_dt) d 
    on
      e.emp_id = d.emp_id
  
    left join
  (select
    w.emp_id,
    w.entry_dt,
    extract(year from w.entry_dt) year,
    extract(month from w.entry_dt) period,
    sum(w.amt) w_amt
  from WITHDRAW w
  where 
    w.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
      and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
    --w.emp_id = 20299
  group by w.emp_id, w.entry_dt)w
    on
      e.emp_id = w.emp_id --and
      --d.emp_id = w.emp_id
order by e.emp_id




--Monthly employee wise deposit
select
  d.emp_id,
  d.entry_dt,
  extract(year from d.entry_dt) year,
  extract(month from d.entry_dt) period,
  nvl(sum(d.amt), 0) d_amt
from DEPOSIT d
where 
  d.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
  --d.emp_id = 20001
group by d.emp_id, d.entry_dt

--Monthly employee wise withdraw
select
  w.emp_id,
  w.entry_dt,
  extract(year from w.entry_dt) year,
  extract(month from w.entry_dt) period,
  sum(w.amt) w_amt
from WITHDRAW w
where 
  w.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
  --w.emp_id = 20299
group by w.emp_id, w.entry_dt


--****************************
select
v1.emp_id,
nvl(v1.d_amt, 0) d_amt,
nvl(v2.w_amt, 0) w_amt,
nvl(v1.d_amt,0) - nvl(v2.w_amt, 0) net_balance
from
(select
  d.emp_id,
  d.entry_dt,
  extract(year from d.entry_dt) year,
  extract(month from d.entry_dt) period,
  nvl(sum(d.amt), 0) d_amt
from DEPOSIT d
where 
  d.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
  --d.emp_id = 20001
group by d.emp_id, d.entry_dt) v1
full join

--Monthly employee wise withdraw
(select
  w.emp_id,
  w.entry_dt,
  extract(year from w.entry_dt) year,
  extract(month from w.entry_dt) period,
  sum(w.amt) w_amt
from WITHDRAW w
where 
  w.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
  --w.emp_id = 20299
group by w.emp_id, w.entry_dt) v2
on v1.emp_id = v2.emp_id
