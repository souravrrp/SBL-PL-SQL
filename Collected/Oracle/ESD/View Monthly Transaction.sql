create or replace view v_Monthly_Transaction
as
--Monthly employee wise deposit
select
    d.emp_id emp_id,
    --d.shop_code shop_code,
    (select SHOP_CODE from emp_info i where i.EMP_ID = d.emp_id) SHOP_CODE,
    d.entry_dt entry_dt,
    --extract(year from d.entry_dt)||'-'||extract(month from d.entry_dt) period,
    nvl(sum(d.amt), 0) amt
from DEPOSIT d
/*where 
  d.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) and
  d.emp_id in (select e.emp_id from EMP_INFO e where e.type = '&emp_type')*/
group by d.emp_id, /*d.shop_code,*/ d.entry_dt --extract(year from d.entry_dt)||'-'||extract(month from d.entry_dt)

union

--Monthly employee wise withdraw
select
  w.emp_id emp_id,
  --w.shop_code shop_code,
  (select SHOP_CODE from emp_info i where i.EMP_ID = w.emp_id) SHOP_CODE,
  w.entry_dt entry_dt,
  --extract(year from w.entry_dt)||'-'||extract(month from w.entry_dt) period,
  (-1) * nvl(sum(w.amt), 0) amt
from WITHDRAW w
/*where 
  w.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
    and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) and
  w.emp_id in (select e.emp_id from EMP_INFO e where e.type = '&emp_type')*/
group by w.emp_id, /*w.shop_code,*/ w.entry_dt --extract(year from w.entry_dt)||'-'||extract(month from w.entry_dt)
