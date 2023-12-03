--Typewise Voucher Row Details with Amount
select r.voucher_type,
       r.voucher_no,
       r.accounting_year,
       r.row_no,
       r.voucher_date,
       r.trans_code,
       r.currency_code,
       r.debet_amount,
       r.credit_amount,
       r.text,
       r.account,
       r.code_b
  from IFSAPP.GEN_LED_VOUCHER_ROW_TAB r
 where r.accounting_year = '&year'
   and r.voucher_type = '&v_type'
   --and r.voucher_no = '&v_no'
 order by r.voucher_no
