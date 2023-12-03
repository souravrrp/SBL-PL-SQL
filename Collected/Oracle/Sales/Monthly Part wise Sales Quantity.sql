select 
    t.year,
    t.period,
    t.sales_part,
    sum(t.total_cash_units) total_cash_units,
    sum(t.total_hire_units) total_hire_units,
    sum(t.total_cash_units) + sum(t.total_hire_units) total_units
from HPNRET_DIRECT_SALES_TAB t
where 
  t.year = '&year_i' and
  t.period = '&period' and
  t.sales_part like '&sales_part'
group by t.year, t.period, t.sales_part
order by t.sales_part
