select * from INFO_SERVICES_RPT t
where t.result_key = 2980830 AND
T.S10 = 'DMK-H2389'
and t.s11 != '2014/02/22'

select distinct (to_char(to_date(t.s11,'YYYY/MM/DD'),'YYYY-MM-DD'))
from INFO_SERVICES_RPT t
where t.result_key = 2974040
