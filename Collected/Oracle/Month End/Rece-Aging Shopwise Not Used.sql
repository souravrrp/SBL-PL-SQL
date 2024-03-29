select v1.shop_code,
       v1.band,
       sum(v1.ACT_OUT_BAL) RECEIVABLE,
       sum(v1.ACTUAL_UCC) ACTUAL_UCC,
       sum(v1.PRESENT_VALUE) PRESENT_VALUE
  from (select h.shop_code,
               h.sales_date,
               h.loc,
               h.outstanding_months,
               --(last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) date_difference,
               --round(((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay)) installment_paid_month,
               --((last_day(to_date('&year_i'||'/'||'&period'||'/1', 'YYYY/MM/DD')) - h.sales_date) - (((h.total_ucc + h.amount_financed - h.act_out_bal) / h.monthly_pay) * 30)) - 30 as age,
               ((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                  'YYYY/MM/DD')) - h.sales_date) -
               (round((h.total_ucc + h.amount_financed - h.act_out_bal) /
                       h.monthly_pay) * 30)) - 30 as aging,
               case
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 30) <= 60 then
                  '000-060'
                 when (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 30) > 60 and
                      (((last_day(to_date('&year_i' || '/' || '&period' || '/1',
                                          'YYYY/MM/DD')) - h.sales_date) -
                      ((h.total_ucc + h.amount_financed - h.act_out_bal) /
                      h.monthly_pay) * 30) - 30) <= 120 then
                  '061-120'
                 else
                  '120 +'
               end band,
               H.ACT_OUT_BAL,
               H.ACTUAL_UCC,
               H.PRESENT_VALUE
          from hpnret_form249_arrears_tab h
         where h.year = '&year_i'
           and h.period = '&period'
           /*and h.acct_no != 'SES-H320'*/
           and h.act_out_bal > 0
        /*group by h.shop_code*/
        ) v1
 group by v1.shop_code, v1.band
 ORDER BY v1.shop_code, BAND
