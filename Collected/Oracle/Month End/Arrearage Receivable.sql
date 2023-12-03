select '0 - 60 Days' Days,
    h.year,
    h.period,
    sum(h.act_out_bal) act_out_bal,
    sum(h.actual_ucc) actual_ucc,
    sum(h.act_out_bal - h.actual_ucc) NET,
    sum(h.present_value) NET2
from HPNRET_FORM249_ARREARS_TAB H
where h.act_out_bal > 0 and
  h.year = '&year_i' and
  h.period = '&period_i' and
  h.arr_mon in (0,1,2)
  --h.del_mon in (0,1,2)
group by h.year, h.period

union

select '61 - 120 Days' Days,
    h.year,
    h.period,    
    sum(h.act_out_bal) act_out_bal,
    sum(h.actual_ucc) actual_ucc,
    sum(h.act_out_bal - h.actual_ucc) NET,
    sum(h.present_value) NET2
from HPNRET_FORM249_ARREARS_TAB H
where h.act_out_bal > 0 and
  h.year = '&year_i' and
  h.period = '&period_i' and
  h.arr_mon in (3,4)
  --h.del_mon in (3,4)
group by h.year, h.period

union

select '120+ Days' Days,
    h.year,
    h.period,    
    sum(h.act_out_bal) act_out_bal,
    sum(h.actual_ucc) actual_ucc,
    sum(h.act_out_bal - h.actual_ucc) NET,
    sum(h.present_value) NET2
from HPNRET_FORM249_ARREARS_TAB H
where h.act_out_bal > 0 and
  h.year = '&year_i' and
  h.period = '&period_i' and
  h.arr_mon > 4
  --h.del_mon > 4
group by h.year, h.period
