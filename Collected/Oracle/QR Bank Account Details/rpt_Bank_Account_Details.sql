--Bank Account Details
select b.proposal_no,
       b.contract,
       b.voucher_date,
       b.DDNO,
       (select IFSAPP.HPNRET_BANK_API.Get_Name(c.bank_id)
          from IFSAPP.CHECK_ENCASHMENT_TAB c
         where c.check_no = b.ledger_item_id
           and c.customer_id = b.identity
           and c.series_id = b.ledger_item_series_id
           and c.rowstate = 'Approved') bank_name,
       b.amount,
       b.ACCOUNT_NO,
       b.ACCOUNT_NO_DT,
       b.ACCOUNT_NAME,
       b.DD_DATE,
       (select c.last_dd_no
          from IFSAPP.CHECK_ENCASHMENT_TAB c
         where c.check_no = b.ledger_item_id
           and c.customer_id = b.identity
           and c.series_id = b.ledger_item_series_id
           and c.rowstate = 'Approved') last_dd_no,
       decode((select c.last_dd_no
                from IFSAPP.CHECK_ENCASHMENT_TAB c
               where c.check_no = b.ledger_item_id
                 and c.customer_id = b.identity
                 and c.series_id = b.ledger_item_series_id
                 and c.rowstate = 'Approved'),
              null,
              b.DDNO,
              (select c.last_dd_no
                 from IFSAPP.CHECK_ENCASHMENT_TAB c
                where c.check_no = b.ledger_item_id
                  and c.customer_id = b.identity
                  and c.series_id = b.ledger_item_series_id
                  and c.rowstate = 'Approved')) DDNO_FINAL,
       b.voucher_type,
       b.voucher_no,
       b.text
  from IFSAPP.SBL_VW_RPT_BANK_ACCT_DTL b
 where b.credit_amount is not null
   and b.ACCOUNT_NO like '&ACCOUNT_NO'
   and b.contract like '&SITE'
   and b.voucher_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and b.credit_amount is not null
   and (select upper(IFSAPP.HPNRET_BANK_API.Get_Name(c.bank_id))
          from IFSAPP.CHECK_ENCASHMENT_TAB c
         where c.check_no = b.ledger_item_id
           and c.customer_id = b.identity
           and c.series_id = b.ledger_item_series_id
           and c.rowstate = 'Approved') like upper('%&BANK_NAME%')
 order by b.proposal_no, b.voucher_date
