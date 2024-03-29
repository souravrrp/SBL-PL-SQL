--Shopwise Product Sales vs Cost of Sales
SELECT a.code_b site_code,
       a.code_c commo_grp,
       /*c.accnt_type,*/
       /*c.logical_account_type,*/
       a.account,
       c.description ACCOUNT_DESC,
       decode(c.accnt_type,
              '400',
              0,
              '500',
              nvl(sum(a.debet_amount),0) - nvl(sum(a.credit_amount),0)) debet_amount,
       decode(c.accnt_type,
              '400',
              nvl(sum(a.credit_amount),0) - nvl(sum(a.debet_amount),0),
              '500',
              0) credit_amount
  FROM ifsapp.gen_led_voucher_row_tab a,
       ifsapp.gen_led_voucher_tab     gl,
       IFSAPP.ACCOUNT                 c
 WHERE a.company = gl.company
   AND a.voucher_type = gl.voucher_type
   AND a.voucher_no = gl.voucher_no
   AND a.accounting_year = gl.accounting_year
   AND a.account = c.ACCOUNT
   and a.code_b like '&Site_Code'
   /*AND a.voucher_date between
       to_date('&YEAR' || "/" || '&PERIOD' || "/1", 'YYYY/MM/DD') AND
       LAST_DAY(to_date('&YEAR' || "/" || '&PERIOD' || "/1", 'YYYY/MM/DD'))*/
   AND trunc(gl.approval_date) between
       to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD') AND
       LAST_DAY(to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD'))
   and c.accnt_type in ('400', '500')
 group by a.account,
          c.accnt_type,
          /*c.logical_account_type,*/
          c.description,
          a.code_b,
          a.code_c
 order by a.code_b, a.code_c, a.account;

--******
SELECT a.code_b site_code,
       a.code_c commo_grp,
       /*c.accnt_type,*/
       /*c.logical_account_type,*/
       a.account,
       c.description ACCOUNT_DESC,
       sum(a.debet_amount) debet_amount,
       sum(a.credit_amount) credit_amount
  FROM ifsapp.gen_led_voucher_row_tab a,
       ifsapp.gen_led_voucher_tab     gl,
       IFSAPP.ACCOUNT                 c
 WHERE a.company = gl.company
   AND a.voucher_type = gl.voucher_type
   AND a.voucher_no = gl.voucher_no
   AND a.accounting_year = gl.accounting_year
   AND a.account = c.ACCOUNT
   /*AND a.voucher_date between
       to_date('&YEAR' || "/" || '&PERIOD' || "/1", 'YYYY/MM/DD') AND
       LAST_DAY(to_date('&YEAR' || "/" || '&PERIOD' || "/1", 'YYYY/MM/DD'))*/
   AND trunc(gl.approval_date) between
       to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD') AND
       LAST_DAY(to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD'))
   and c.accnt_type in ('400', '500')
 group by a.account,
          /*c.accnt_type,*/
          /*c.logical_account_type,*/
          c.description,
          a.code_b,
          a.code_c
 order by a.code_b, a.code_c, a.account;
