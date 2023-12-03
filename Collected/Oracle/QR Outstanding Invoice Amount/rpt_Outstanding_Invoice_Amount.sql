select g.company,
       g.accounting_year,
       g.accounting_period,
       --g.voucher_type,
       --g.voucher_no,
       --g.voucher_date,
       g.account,
       g.account_desc,
       g.code_b,
       g.code_b_desc,
       --g.trans_code,
       --g.text,
       sum(g.debet_amount) total_debet_amount,
       sum(g.credit_amount) total_credit_amount,
       sum(g.amount) total_amount
       --count(*)
  from IFSAPP.GL_AND_HOLD_VOU_ROW_QRY g
 where g.accounting_year = '&accounting_year'
   and g.accounting_period = '&accounting_period'
   and g.account = '10100020' --'&account'
 group by g.company, g.accounting_year, g.accounting_period, g.account, g.account_desc, g.code_b, g.code_b_desc
 order by g.code_b --g.voucher_no
