/* Formatted on 3/20/2023 4:07:06 PM (QP5 v5.381) */
SELECT pt.pay_date,
       pt.voucher_date,
       pt.accounting_year,
       pt.voucher_type,
       pt.user_group,
       pt.userid,
       pt.voucher_no,
       pt.payment_type_code,
       pt.note,
       pt.payment_rollback_status,
       pt.payment_ledger_type,
       --,pt.*
       ptt.*
  FROM ifsapp.payment_tab pt, ifsapp.payment_transaction_tab ptt
 WHERE     1 = 1
       AND pt.voucher_no = '2300293789'
       --AND company = 'SBL'
       --AND   series_id = series_id_
       AND pt.payment_id = ptt.payment_id(+);