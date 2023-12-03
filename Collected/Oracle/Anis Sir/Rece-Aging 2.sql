--select * from hpnret_form249_arrears_tab h

select
    v1.band,
    sum(v1.ACT_OUT_BAL) RECEIVABLE,
    sum(v1.ACTUAL_UCC) ACTUAL_UCC,
    sum(v1.PRESENT_VALUE) PRESENT_VALUE
from
(select 
    --h.actual_sales_date,
    h.sales_date,
    h.loc,
    h.outstanding_months,
    --(last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) date_difference,
    --round(((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay)) installment_paid_month,
    ((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) 
        - (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30)) - 30 as aging,
    case when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) 
                  - (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30)) -30) <= 0 then '000 -'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) 
              - (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) >= 1
        and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) 
              - (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30)) -30) <= 30 then '001-030'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) 
              - (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) >= 31 
        and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) 
              - (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 120 then '031-120'      
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) 
              - (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) >= 121 
        and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) 
              - (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 365 then '121-365'
      else '365+'
      end band,
    H.ACT_OUT_BAL,
    H.ACTUAL_UCC,
    H.PRESENT_VALUE  
from 
  hpnret_form249_arrears_tab h
where
  h.year = '&year_i' and
  h.period = '&period' and
  h.act_out_bal > 0) v1
group by v1.band
ORDER BY BAND
