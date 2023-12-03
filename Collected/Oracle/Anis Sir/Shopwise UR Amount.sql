--*****
select *
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB t
 where t.account = '10100900'
   and t.accounting_year = 2018
   and t.accounting_period = 12
   and t.code_b = 'TEKB';

--*****
select t.accounting_year, t.code_b,  /*sum(t.debet_amount),*/ sum(t.credit_amount) UR_AMOUNT
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB t
 inner join ifsapp.shop_dts_info s
    on t.code_b = s.shop_code
 where t.account = '10100900'
   and t.accounting_year = 2018
   /*and t.accounting_period = 12*/
   /*and t.code_b = 'TEKB'*/
 group by t.accounting_year, t.code_b
/*having sum(t.debet_amount) - sum(t.credit_amount) != 0*/;
