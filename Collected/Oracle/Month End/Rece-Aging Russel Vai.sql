select v1.band,
       sum(v1.ACT_OUT_BAL) RECEIVABLE,
       sum(v1.ACTUAL_UCC) ACTUAL_UCC,
       sum(v1.PRESENT_VALUE) PRESENT_VALUE
  from (select h.sales_date,
               h.loc,
               h.outstanding_months,
               ((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                  'YYYY/MM/DD')) - h.sales_date) -
               (round((h.total_ucc + h.amount_financed - h.act_out_bal) /
                       h.monthly_pay) * 30)) - 30 as aging,
               case
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      (round((h.total_ucc + h.amount_financed -
                               h.act_out_bal) / h.monthly_pay) * 30)) - 30) <= 60 then
                  '000-060'
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      (round((h.total_ucc + h.amount_financed -
                               h.act_out_bal) / h.monthly_pay) * 30) - 30)) > 60 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      (round((h.total_ucc + h.amount_financed -
                               h.act_out_bal) / h.monthly_pay) * 30) - 30)) <= 120 then
                  '061-120'
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      (round((h.total_ucc + h.amount_financed -
                               h.act_out_bal) / h.monthly_pay) * 30) - 30)) > 120 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      (round((h.total_ucc + h.amount_financed -
                               h.act_out_bal) / h.monthly_pay) * 30) - 30)) <= 365 then
                  '121-365'
               /*when (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
                 (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) > 270 and 
               (((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - 
                 (round((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30) -30)) <= 365 
               then '271-365'*/
                 else
                  '365+'
               end band,
               H.ACT_OUT_BAL,
               H.ACTUAL_UCC,
               H.PRESENT_VALUE
          from hpnret_form249_arrears_tab h
         where h.year = '&year_i'
           and h.period = '&period'
           /*and h.acct_no != 'DBL-H2291'*/ --'FLP-H2816' --'SES-H320'
           and h.act_out_bal > 0
           and h.shop_code not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
           and h.shop_code not in
               ('SAPM', 'SCOM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
        ) v1
 group by v1.band
 ORDER BY BAND