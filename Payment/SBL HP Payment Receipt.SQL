/* Formatted on 3/20/2023 2:18:23 PM (QP5 v5.381) */
SELECT hprht.contract,
       hprht.receipt_no       receipt_number,
       hprht.receipt_date     rcpt_date,
       hprht.rowstate         receipt_status,
       hprht.vat_receipt      vat_receipt_no,
       hprt.amount,
       hprt.voucher_no        voucher_number,
       hprt.voucher_type      vchr_type,
       hprt.voucher_date      vchr_date,
       hprt.rowstate          pay_status,
       hprht.account_no       order_number
  --,hprht.*
  --,hprt.*
  FROM ifsapp.hpnret_pay_receipt_head_tab  hprht,
       ifsapp.hpnret_pay_receipt_tab       hprt
 WHERE     1 = 1
       AND hprht.receipt_no = hprt.receipt_no(+)
       --and hprht.receipt_no in ('cdg-c10924')
       AND (   :p_receipt_no IS NULL
            OR (UPPER (hprht.receipt_no) = UPPER ( :p_receipt_no)))
       AND (   :p_order_no IS NULL
            OR (UPPER (hprht.account_no) = UPPER ( :p_order_no)))
       AND (   :p_voucher_no IS NULL
            OR (UPPER (hprt.voucher_no) = UPPER ( :p_voucher_no)));

--------------------------------HP Sales----------------------------------------

SELECT *
  FROM ifsapp.hpnret_pay_receipt_head_tab hprht
 WHERE     1 = 1
       --AND hprht.receipt_no IN ('CDG-C10924')
       AND (   :p_order_no IS NULL
            OR (UPPER (hprht.account_no) = UPPER ( :p_order_no)))
       AND (   :p_receipt_no IS NULL
            OR (UPPER (hprht.receipt_no) = UPPER ( :p_receipt_no)));

SELECT *
  FROM ifsapp.hpnret_pay_receipt_tab hprt
 WHERE     1 = 1
       --AND hprt.receipt_no IN ('CDG-C10924')
       AND (   :p_receipt_no IS NULL
            OR (UPPER (hprt.receipt_no) = UPPER ( :p_receipt_no)));