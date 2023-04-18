/* Formatted on 3/20/2023 3:54:57 PM (QP5 v5.381) */
SELECT pay_date,
       voucher_date,
       accounting_year,
       voucher_type,
       user_group,
       userid,
       voucher_no,
       payment_type_code,
       note,
       payment_rollback_status,
       payment_ledger_type,
       pt.*
  FROM ifsapp.payment_tab pt
 WHERE company = 'SBL' AND voucher_no = '2300293789'
--AND   series_id = series_id_
--AND   payment_id = payment_id_
;
--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.payment_series_tab pt;

SELECT *
  FROM ifsapp.payment_transaction_tab ptt;

SELECT *
  FROM ifsapp.payment_term_tab ptt;

SELECT *
  FROM ifsapp.payment_type_tab ptt;