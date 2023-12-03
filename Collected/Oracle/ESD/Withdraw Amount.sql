select
  t.EMP_ID,
  to_char(t.ENTRY_DT,'yyyy-mm') ENTRY_DT,
  sum(AMT) AMT,
  (select SHOP_CODE from emp_info i where t.EMP_ID = i.EMP_ID and i.TYPE = 1 and i.VALID = 1) SHOP_CODE,                
  (select NAME from emp_info i where i.EMP_ID = t.EMP_ID and i.TYPE = 1 and i.VALID = 1) NAME
from
  withdraw t,
  emp_info e
where 
  t.emp_id = e.EMP_ID and 
  e.TYPE = 1 and 
  e.VALID = 1 and
  to_char(t.ENTRY_DT,'yyyy-mm') between '2013-01' and '2013-12'
group by to_char(t.ENTRY_DT,'yyyy-mm'),t.EMP_ID,t.SHOP_CODE
order by t.SHOP_CODE
