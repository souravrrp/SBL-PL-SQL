select
  t.EMP_ID,
  --t.entry_dt,
  --extract(year from to_date(t.entry_dt, 'MM/DD/YYYY')) entry_dt,
  to_char(t.ENTRY_DT,'yyyy-mm') ENTRY_DT,
  sum(AMT) AMT,
  (select SHOP_CODE from emp_info i where t.EMP_ID=i.EMP_ID and i.TYPE=1 and i.VALID=1) SHOP_CODE ,
  (select i.NAME from emp_info i where i.EMP_ID = t.EMP_ID and i.TYPE=1 and i.VALID=1) NAME
from
  deposit t,
  emp_info e
where 
  t.emp_id=e.EMP_ID and 
  e.TYPE=1 and 
  e.VALID=1 and
  t.emp_id = '20434' --and
  --to_char(t.ENTRY_DT,'yyyy-mm') between '2013-05' and '2013-12'
group by to_char(t.ENTRY_DT,'yyyy-mm'),t.EMP_ID--,t.SHOP_CODE
order by SHOP_CODE
