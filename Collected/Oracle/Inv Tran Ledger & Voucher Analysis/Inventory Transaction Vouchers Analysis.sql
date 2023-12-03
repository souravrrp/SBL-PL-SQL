--Inventory Transaction Vouchers Analysis
SELECT a.voucher_type,
       a.voucher_no,
       a.voucher_date,
       trunc(gl.date_reg) date_reg,
       trunc(gl.approval_date) approval_date,
       a.row_no,
       a.debet_amount,
       a.credit_amount,
       a.quantity,
       a.account,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', a.ACCOUNT) ACCOUNT_DESC,
       a.code_b,
       a.code_c,
       a.mpccom_accounting_id,
       a.accounting_year,
       a.accounting_period,
       a.trans_code,
       a.text,
       a.party_type_id,
       a.reference_serie,
       a.reference_number,
       gl.jou_no,
       gl.function_group,
       a.posting_combination_id,
       a.internal_seq_number,
       gl.approved_by_userid
  FROM gen_led_voucher_row_tab a, gen_led_voucher_tab gl
 WHERE a.company = gl.company
   AND a.voucher_type = gl.voucher_type
   AND a.voucher_no = gl.voucher_no
   AND a.accounting_year = gl.accounting_year
   /*AND a.voucher_date between to_date('2017/8/1', 'YYYY/MM/DD') AND
       to_date('2017/8/14', 'YYYY/MM/DD')
   AND trunc(gl.approval_date) >= to_date('2017/11/1', 'YYYY/MM/DD')*/
   and a.voucher_type = '&voucher_type' --'F'
   and a.voucher_no = '&voucher_no' --'1700435749' '1700587531'
   /*and gl.jou_no = '2406'*/
   /*and a.party_type_id = 'I0000335-1'*/ /*'4566078'*/
 order by a.voucher_no, a.row_no
