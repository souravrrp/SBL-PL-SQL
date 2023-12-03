select  
distinct 
TO_NUMBER(SUBSTR(L.District, INSTR(L.District, ' ') + 1, 2))
from 
HPNRET_LEVELS_OVERVIEW L


select AREA, 
DISTRICT,
TO_NUMBER(SUBSTR(h.District, INSTR(h.District, ' ') + 1, 2)) DISTRICT_CODE, 
to_char(s.SALE_DATE,'yyyy-mm-dd') SALE_DATE,
sum(s.nsp) NSP 
from SBL_SALEs_TMP s, HPNRET_LEVELS_OVERVIEW h where h.SITE_ID=s.SHOP_CODE 
and h.CHANNEL in ('Retail 1 Sub Channel','Mega Sub Channel') 
and s.SALE_DATE between to_date('&date_to','dd/mm/yyyy') and to_date('&date_from','dd/mm/yyyy') 
group by DISTRICT,AREA,s.SALE_DATE  order by AREA,DISTRICT
