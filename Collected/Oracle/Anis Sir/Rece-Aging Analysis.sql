select
    v1.band,
    count(v1.acct_no) no_of_accts,
    sum(v1.ACT_OUT_BAL) RECEIVABLE,
    sum(v1.ACTUAL_UCC) ACTUAL_UCC,
    sum(v1.PRESENT_VALUE) PRESENT_VALUE
from
(select 
    h.acct_no,
    h.sales_date,
    h.loc,
    h.outstanding_months,
    ((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30)) - 30 as aging,    
    case when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30)) -30) <= 0 then '00'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 0 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 30 then '01'      
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 30 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 60 then '02'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 60 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 90 then '03'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 90 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 120 then '04'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 120 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 150 then '05'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 150 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 180 then '06'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 180 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 210 then '07'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 210 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 240 then '08'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 240 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 270 then '09'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 270 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 300 then '10'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 300 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 330 then '11'
      when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 330 
          and (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
          (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 365 then '12'
      else '12+'
      end band,
    H.ACT_OUT_BAL,
    H.ACTUAL_UCC,
    H.PRESENT_VALUE  
from 
  hpnret_form249_arrears_tab h
where
  h.year = '&year_i' and
  h.period = '&period' and
  h.acct_no != 'SES-H320' and
  h.act_out_bal > 0) v1
group by v1.band
ORDER BY BAND
