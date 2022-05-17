select v.YEAR,
       v.period,
       v.band,
       sum(v.act_out_bal) as receivable,
       sum(v.actual_ucc) as actual_ucc,
       sum(v.present_value) as present_value
       from(select t.*,
                   
       ((last_day(TO_DATE(t.year || '/' || t.period||'/1' ,
                         'YYYY/MM/DD')) - T.sales_date) -(round((t.total_ucc + t.amount_financed -t.act_out_bal) / t.monthly_pay) * 30)) - 30 as AGING,
              CASE
       
         when (((last_day(TO_DATE(t.year || '/' || t.period ||
                                 '/1',
                                 'YYYY/MM/DD')) - T.sales_date)
               -(round((t.total_ucc + t.amount_financed - t.act_out_bal) /
                       monthly_pay) * 30)) - 30) <= 60 then
          '000-060'
       
         when (((last_day(TO_DATE(t.year || '/' || t.period ||
                                 '/1',
                                 'YYYY/MM/DD')) - t.sales_date)
               -(round((t.total_ucc + t.amount_financed - t.act_out_bal) /
                       t.monthly_pay) * 30)) - 30) >60 and
                 
               (((last_day(TO_DATE(t.year || '/' || t.period ||
                                 '/1',
                                 'YYYY/MM/DD')) - t.sales_date)
               -(round((t.total_ucc + t.amount_financed - t.act_out_bal) /
                       t.monthly_pay) * 30)) - 30) <=120 then                        
                    
          '061-120'
          
          when (((last_day(TO_DATE(t.year || '/' || t.period ||
                                 '/1',
                                 'YYYY/MM/DD')) - t.sales_date)
               -(round((t.total_ucc + t.amount_financed - t.act_out_bal) /
                       monthly_pay) * 30)) - 30) >120 and
                 
              (((last_day(TO_DATE(t.year || '/' || t.period ||
                                 '/1',
                                 'YYYY/MM/DD')) - t.sales_date)
               -(round((t.total_ucc + t.amount_financed - t.act_out_bal) /
                       monthly_pay) * 30)) - 30) <=365 then
                 '121-365'                        
                    
       /*
         when ((last_day(TO_DATE(t.year || '/' || t.period ||
                                 '/01',
                                 'YYYY/MM/DD')) – sales_date)
               –(round((total_ucc + amount_financed – act_out_bal) /
                       monthly_pay) * 30) - 30) <= 365 then
          '121-365'*/
                    
         else
          '365+'
       END band
       
       /*sum(act_out_bal) as receivable,
       sum(actual_ucc) as actual_ucc,
       sum(present_value) as present_value*/
  from hpnret_form249_arrears_tab t
  where to_number(case
         when length(CONCAT(to_char(t.year), to_char(t.period))) = 5 then
          to_char(t.year) || '0' || to_char(t.period)
         when length(CONCAT(to_char(t.year), to_char(t.period))) = 6 then
          CONCAT(to_char(t.year), to_char(t.period)) 
       end) between to_number(case
         when length(concat('&start_year', '&start_period')) = 5 then
          '&start_year' || '0' || '&start_period'
         when length(concat('&start_year', '&start_period')) = 6 then
          concat('&start_year', '&start_period')
       end) and to_number(case
         when length(concat('&end_year', '&end_period')) = 5 then
          '&end_year' || '0' || '&end_period'
         when length(concat('&end_year', '&end_period')) = 6 then
          concat('&end_year', '&end_period')
       end)
 AND t.act_out_bal > 0
           AND t.shop_code NOT IN ('JWSS',
                                   'SAOS',
                                   'SWSS',
                                   'WSMO',
                                   'SITM',
                                   'SSAM',
                                   'WITM', --Wholesale Sites
                                   'SAPM',
                                   'SCOM',
                                   'SCSM',
                                   'SESM',
                                   'SHOM',
                                   'SISM',
                                   'SFSM',
                                   'SOSM') --Corporate, Employee, & Scrap Sites
        ) v
 GROUP BY v.year, v.period, v.band
 ORDER BY 1, 2, 3
