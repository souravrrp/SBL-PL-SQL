--Opening deposit balance
select
  (select e.shop_code from EMP_INFO e where e.emp_id = d.emp_id) shop_code,
  d.emp_id,
  (select e.name from EMP_INFO e where e.emp_id = d.emp_id) emp_name,
  nvl(sum(d.amt), 0) open_deposit_amt
from DEPOSIT d
where 
  d.entry_dt < trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') and
  d.emp_id = 20355
group by d.emp_id
order by d.emp_id

--Opening withdraw balance
select
  (select e.shop_code from EMP_INFO e where e.emp_id = w.emp_id) shop_code,
  w.emp_id,
  (select e.name from EMP_INFO e where e.emp_id = w.emp_id) emp_name,
  nvl(sum(w.amt), 0) open_deposit_amt
from WITHDRAW w
where 
  w.entry_dt < trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') --and
  --w.emp_id = 20355
group by w.emp_id
order by w.emp_id

--Opening Balance
select
  v_Open_Deposit.shop_code,
  v_Open_Deposit.emp_id,
  v_Open_Deposit.emp_name,
  'Opening Balance' period,
  --nvl(v_Open_Deposit.open_deposit_amt, 0) open_deposit_amt,
  --nvl(v_Open_Withdraw.open_withdraw_amt, 0) open_withdraw_amt,
  nvl(v_Open_Deposit.open_deposit_amt, 0) - nvl(v_Open_Withdraw.open_withdraw_amt, 0) opening_balance
from
  (select
    (select e.shop_code from EMP_INFO e where e.emp_id = d.emp_id) shop_code,
    d.emp_id,
    (select e.name from EMP_INFO e where e.emp_id = d.emp_id) emp_name,
    nvl(sum(d.amt), 0) open_deposit_amt
  from DEPOSIT d
  where 
    d.entry_dt < trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') --and
    --d.emp_id = 20355
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
    w.entry_dt < trunc(to_date('&year_1'||'/'||'&month_1'||'/1', 'YYYY/MM/DD'), 'MM') --and
    --w.emp_id = 20355
  group by w.emp_id
  order by w.emp_id
  )v_Open_Withdraw
 
 on 
 v_Open_Deposit.shop_code = v_Open_Withdraw.shop_code and
 v_Open_Deposit.emp_id = v_Open_Withdraw.emp_id
order by emp_id
