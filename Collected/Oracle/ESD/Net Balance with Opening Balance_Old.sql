--Opening deposit balance
select
  v_Open_Deposit.emp_id,
  v_Open_Deposit.shop_code,  
  v_Open_Deposit.emp_name,
  'Opening Balance' period,
  --nvl(v_Open_Deposit.open_deposit_amt, 0) open_deposit_amt,
  --nvl(v_Open_Withdraw.open_withdraw_amt, 0) open_withdraw_amt,
  nvl(v_Open_Deposit.open_deposit_amt, 0) - nvl(v_Open_Withdraw.open_withdraw_amt, 0) balance
from
  (select
    (select e.shop_code from EMP_INFO e where e.emp_id = d.emp_id) shop_code,
    d.emp_id,
    (select e.name from EMP_INFO e where e.emp_id = d.emp_id) emp_name,
    nvl(sum(d.amt), 0) open_deposit_amt
  from DEPOSIT d
  where 
    d.entry_dt < trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') and
    d.emp_id in (select e.emp_id from EMP_INFO e where e.type = '&emp_type') 
  group by d.emp_id
  order by d.emp_id
  )v_Open_Deposit 
  
  left join
  
  (select
    (select e.shop_code from EMP_INFO e where e.emp_id = w.emp_id) shop_code,
    w.emp_id,
    (select e.name from EMP_INFO e where e.emp_id = w.emp_id) emp_name,
    nvl(sum(w.amt), 0) open_withdraw_amt
  from WITHDRAW w
  where 
    w.entry_dt < trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') and
    w.emp_id in (select e.emp_id from EMP_INFO e where e.type = '&emp_type')
  group by w.emp_id
  order by w.emp_id
  )v_Open_Withdraw
 
 on 
 v_Open_Deposit.shop_code = v_Open_Withdraw.shop_code and
 v_Open_Deposit.emp_id = v_Open_Withdraw.emp_id

union

--Month wise net balance
select
  v_Monthly_Deposit.shop_code,
  v_Monthly_Deposit.emp_id,
  v_Monthly_Deposit.emp_name,
  v_Monthly_Deposit.period,
  nvl(v_Monthly_Deposit.d_amt, 0) - nvl(v_Monthly_Withdraw.w_amt, 0) balance
from
--Month wise sum deposit
  (select
    (select e.shop_code from EMP_INFO e where e.emp_id = d.emp_id) shop_code,
    d.emp_id emp_id,
    (select e.name from EMP_INFO e where e.emp_id = d.emp_id) emp_name,
    extract(year from d.entry_dt)||'-'||extract(month from d.entry_dt) period,
    nvl(sum(d.amt), 0) d_amt
  from DEPOSIT d
  where 
    d.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
      and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) and
    d.emp_id in (select e.emp_id from EMP_INFO e where e.type = '&emp_type')
  group by d.emp_id, extract(year from d.entry_dt)||'-'||extract(month from d.entry_dt)
  order by d.emp_id, period)v_Monthly_Deposit
  
  full join

--Month wise sum withdraw
  (select
    (select e.shop_code from EMP_INFO e where e.emp_id = w.emp_id) shop_code,
    w.emp_id emp_id,
    (select e.name from EMP_INFO e where e.emp_id = w.emp_id) emp_name,
    extract(year from w.entry_dt)||'-'||extract(month from w.entry_dt) period,
    nvl(sum(w.amt), 0) w_amt
  from WITHDRAW w
  where 
    w.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
      and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) and
    w.emp_id in (select e.emp_id from EMP_INFO e where e.type = '&emp_type')
  group by w.emp_id, extract(year from w.entry_dt)||'-'||extract(month from w.entry_dt)
  order by w.emp_id, period)v_Monthly_Withdraw
  
  on
  --where
  
  v_Monthly_Deposit.emp_id = v_Monthly_Withdraw.emp_id and
  v_Monthly_Deposit.period = v_Monthly_Withdraw.period

--group by shop_code, emp_id, emp_name, period 
order by shop_code, emp_id, period
