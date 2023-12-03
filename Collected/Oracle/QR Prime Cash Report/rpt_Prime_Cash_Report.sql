select 
    v.SITE_CODE,
    TO_CHAR(APPROVAL_DT,'YYYY/MM/DD') APPROVAL_DT, 
    v.ACCOUNT_CODE,
    v.NAME, 
    v.AMOUNT 
from 
  sbl_vw_prime_cash v
where 
  v.APPROVAL_DT between TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND TO_DATE('&END_DATE', 'YYYY/MM/DD') 
order by v.SITE_CODE
