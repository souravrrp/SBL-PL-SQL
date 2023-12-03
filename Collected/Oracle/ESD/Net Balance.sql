select
  v_Monthly_Deposit.shop_code,
  v_Monthly_Deposit.emp_id,
  v_Monthly_Deposit.emp_name,
  v_Monthly_Deposit.period,
  nvl(v_Monthly_Deposit.d_amt, 0) deposit_amt,
  nvl(v_Monthly_Withdraw.w_amt, 0) withdraw_amt,
  nvl(v_Monthly_Deposit.d_amt, 0) - nvl(v_Monthly_Withdraw.w_amt, 0) balance
from
--Month wise sum deposit
  (select
    (select e.shop_code from EMP_INFO e where e.emp_id = d.emp_id) shop_code,
    d.emp_id,
    (select e.name from EMP_INFO e where e.emp_id = d.emp_id) emp_name,
    extract(year from d.entry_dt)||'-'||extract(month from d.entry_dt) period,
    nvl(sum(d.amt), 0) d_amt
  from DEPOSIT d
  where 
    d.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
      and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
    --d.emp_id = 20355
  group by d.emp_id, extract(year from d.entry_dt)||'-'||extract(month from d.entry_dt)
  order by d.emp_id, period)v_Monthly_Deposit
  
  left join

--Month wise sum withdraw
  (select
    (select e.shop_code from EMP_INFO e where e.emp_id = w.emp_id) shop_code,
    w.emp_id,
    (select e.name from EMP_INFO e where e.emp_id = w.emp_id) emp_name,
    extract(year from w.entry_dt)||'-'||extract(month from w.entry_dt) period,
    nvl(sum(w.amt), 0) w_amt
  from WITHDRAW w
  where 
    w.entry_dt between trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') 
      and last_day(to_date('&year_2'||'/'||'&month_2'||'/1', 'YYYY/MM/DD')) --and
    --w.emp_id = 20207
  group by w.emp_id, extract(year from w.entry_dt)||'-'||extract(month from w.entry_dt)
  order by w.emp_id, period)v_Monthly_Withdraw
  
  on
  
  v_Monthly_Deposit.emp_id = v_Monthly_Withdraw.emp_id and
  --v_Monthly_Deposit.shop_code = v_Monthly_Withdraw.shop_code and
  v_Monthly_Deposit.period = v_Monthly_Withdraw.period
  
order by emp_id, period
