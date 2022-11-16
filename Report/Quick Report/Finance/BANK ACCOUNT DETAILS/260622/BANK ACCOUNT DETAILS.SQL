select b.proposal_no,
       b.contract,
       b.voucher_date,
       b.DDNO,
       b.bank_name,
       b.amount,
       b.ACCOUNT_NO,
       b.ACCOUNT_NO_DT,
       b.ACCOUNT_NAME,
       b.DD_DATE,
       b.last_dd_no,
       b.DDNO_FINAL,
       b.voucher_type,
       b.voucher_no,
       b.text,
       b.remarks
  from IFSAPP.SBL_VW_RPT_BANK_ACCT_DTL b
 where b.credit_amount is not null
   and b.ACCOUNT_NO like '&ACCOUNT_NO'
   and b.contract like '&SITE'
   and b.voucher_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and upper(b.bank_name) like upper('%&BANK_NAME%')
 order by b.proposal_no, b.voucher_date