select * from HPNRET_DIRECT_SALES t

select 
    t.year,
    t.period,
    sum(T.total_net_hire_cash_value) total_net_hire_cash_value,
    sum(t.total_hire_value) total_hire_value,
    sum(t.total_list_value) total_list_value,
    sum(t.total_first_payment) total_first_payment,
    sum(t.total_hire_units) total_hire_units,
    sum(t.total_cash_units) total_cash_units,
    sum(t.cash_value) cash_value
from HPNRET_DIRECT_SALES t
group by t.year, t.period
