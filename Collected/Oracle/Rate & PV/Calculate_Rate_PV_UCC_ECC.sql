--update table with effective rate, present value, actual ucc & effective ecc data
--Calculate interest rate for a period
update hpnret_form249_arrears_tab t
   set t.effective_rate = fn_Rate(t.amount_financed, t.monthly_pay, loc)
 where t.year = '&year'
   and t.period = '&period'
   and t.act_out_bal > 0;
   --and t.acct_no != 'DBL-H2291';
   --and t.shop_code = '&shop_code'       
commit;

--Calculate present value for a period
update hpnret_form249_arrears_tab t
   set t.present_value = fn_PV(t.effective_rate,
                               t.monthly_pay,
                               t.act_out_bal / t.monthly_pay)
 where t.year = '&year'
   and t.period = '&period'
   and t.act_out_bal > 0;
   --and t.monthly_pay > 0; --Problem FLP-H2816 from 2016-2
   --and t.acct_no != 'DBL-H2291'; --'SES-H320'
commit;

--Calculate actual ucc for a period
update hpnret_form249_arrears_tab t
   set t.actual_ucc = t.act_out_bal - t.present_value
 where t.year = '&year'
   and t.period = '&period'
   and t.act_out_bal > 0;
   --and t.acct_no != 'DBL-H2291';
   /*and t.monthly_pay > 0;*/ --Problem FLP-H2816 from 2016-2
commit;

--Calculate effective ecc for a period
update hpnret_form249_arrears_tab t
   set t.effective_ecc = t.total_ucc - t.actual_ucc
 where t.year = '&year'
   and t.period = '&period'
   and t.act_out_bal > 0;
   --and t.acct_no != 'DBL-H2291';
   /*and t.monthly_pay > 0;*/ --Problem FLP-H2816 from 2016-2
commit;
