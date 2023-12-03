--***** Past Due Aging
select v1.band,
       sum(v1.ACT_OUT_BAL) PAST_DUE_RECEIVABLE,
       sum(v1.ACTUAL_UCC) ACTUAL_UCC,
       sum(v1.PRESENT_VALUE) PRESENT_VALUE
  from (select h.*,
               --(last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) date_difference,
               --round(((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay)) installment_paid_month,
               --((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - (((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30)) - 30 as age,
               ((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                  'YYYY/MM/DD')) - h.sales_date) -
               (round((h.total_ucc + h.amount_financed - h.act_out_bal) /
                       h.monthly_pay) * 30)) - 60 as past_due_aging,
               case
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 0 then
                  '000'
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 0 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 30 then
                  '001-030'
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 30 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 60 then
                  '031-060'
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 60 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 90 then
                  '061-090'
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 90 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 120 then
                  '091-120'
                  when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 120 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 150 then
                  '121-150'
                  when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 150 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 180 then
                  '151-180'
                  when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 180 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 210 then
                  '181-210'
                  when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 210 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 240 then
                  '211-240'
                  when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 240 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 270 then
                  '241-270'
                  when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 270 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 300 then
                  '271-300'
                  when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 300 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 330 then
                  '301-330'
                  when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) > 330 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 60) <= 360 then
                  '331-360'
               else
               '360+'
               end band
          from hpnret_form249_arrears_tab h
         where h.year = '&year_i'
           and h.period = '&period'
           and h.act_out_bal > 0
              --and h.acct_no != 'SES-H320'
           /*and h.shop_code not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
           and h.shop_code not in
               ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM')*/ --Corporate, Employee, & Scrap Sites
        ) v1
 group by v1.band
 ORDER BY v1.band
