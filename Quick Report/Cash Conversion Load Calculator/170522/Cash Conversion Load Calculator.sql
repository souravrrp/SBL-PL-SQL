select h.acct_no,case when h.acct_no != h.original_acct_no then h.last_variation else h.state end remarks,
to_char(h.actual_sales_date, 'YYYY/MM/DD') actual_sales_date, to_char(h.cash_conversion_on_date, 'YYYY/MM/DD') cc_date,
to_char(h.hire_cash_price - h.down_payment - nvl((select sum(c.amount) amount from ifsapp.SBL_COLLECTION_INFO c where c.original_acc_no = h.original_acct_no
and c.payment_date <= h.cash_conversion_on_date),0)) cc_date_balance,to_char(h.cash_conversion_on_date + 25, 'YYYY/MM/DD') last_date_4pc_cc,
cast(case when h.cash_conversion_on_date < sysdate then (h.hire_cash_price - h.down_payment - nvl((select sum(c.amount) amount from ifsapp.SBL_COLLECTION_INFO c
where c.original_acc_no = h.original_acct_no and c.payment_date <= h.cash_conversion_on_date),0)) * 0.04 else 0 end as varchar2(40)) "4PC_LOAD_VALUE",
to_char(h.cash_conversion_on_date + 55, 'YYYY/MM/DD') last_date_8pc_cc,cast(case when h.cash_conversion_on_date < sysdate then 
(h.hire_cash_price - h.down_payment - nvl((select sum(c.amount) amount from ifsapp.SBL_COLLECTION_INFO c where c.original_acc_no = h.original_acct_no
and c.payment_date <= h.cash_conversion_on_date),0)) * 0.08 else 0 end as varchar2(40)) "8PC_LOAD_VALUE" from ifsapp.HPNRET_FORM249_ARREARS h
where h.year = to_number(to_char(SYSDATE,'YYYY')) and h.period = to_number(to_char(SYSDATE,'MM')-1) and h.act_out_bal > 0
and h.acct_no = h.original_acct_no and h.acct_no = '&ACCT_NO'
union all
select h.acct_no,case when h.acct_no != h.original_acct_no then h.last_variation else h.state end remarks,'' actual_sales_date,'' cc_date,
'' cc_date_balance,'' last_date_4pc_cc,'' "4PC_LOAD_VALUE",'' last_date_8pc_cc,'' "8PC_LOAD_VALUE" from ifsapp.HPNRET_FORM249_ARREARS h
where h.year = to_number(to_char(SYSDATE,'YYYY')) and h.period = to_number(to_char(SYSDATE,'MM')-1) and h.act_out_bal > 0
and h.acct_no != h.original_acct_no and h.acct_no = '&ACCT_NO'