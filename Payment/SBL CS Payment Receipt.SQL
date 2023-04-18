/* Formatted on 3/20/2023 12:31:41 PM (QP5 v5.381) */
SELECT hcpht.contract,
       hcpht.customer_no,
       hcpht.pay_no             payment_no,
       hcpht.receipt_no         receipt_number,
       hcpht.receipt_date       rcpt_date,
       hcpht.rowstate           receipt_status,
       hcpht.vat_receipt        vat_receipt_no,
       hcpdt.payment_method     pay_method,
       hcpdt.curr_amount        amount,
       hcpdt.voucher_no         voucher_number,
       hcpdt.voucher_type       vchr_type,
       hcpdt.voucher_date       vchr_date,
       hcpdt.rowstate           pay_status,
       hcpdt.lump_sum_trans_date      trans_date,
       hcpdt.order_no           order_number
  --,hcpht.*
  --,hcpdt.*
  FROM ifsapp.hpnret_co_pay_head_tab  hcpht,
       ifsapp.hpnret_co_pay_dtl_tab   hcpdt
 WHERE     1 = 1
       AND hcpht.pay_no = hcpdt.pay_no(+)
       --and hcpht.receipt_no in ('cdg-c10924')
       --and hcpht.pay_no='1401383'
       AND (   :p_receipt_no IS NULL
            OR (UPPER (hcpht.receipt_no) = UPPER ( :p_receipt_no)))
       AND (   :p_order_no IS NULL
            OR (UPPER (hcpdt.order_no) = UPPER ( :p_order_no)))
       AND (   :p_voucher_no IS NULL
            OR (UPPER (hcpdt.voucher_no) = UPPER ( :p_voucher_no)));

--------------------------------cash sales--------------------------------------

SELECT *
  FROM ifsapp.hpnret_co_pay_head_tab hcpht
 WHERE     1 = 1
       --and hcpht.receipt_no in ('cdg-c10924')
       --and hcpht.pay_no='1401383'
       AND (   :p_receipt_no IS NULL
            OR (UPPER (hcpht.receipt_no) = UPPER ( :p_receipt_no)));

SELECT *
  FROM ifsapp.hpnret_co_pay_dtl_tab hcpdt
 WHERE     1 = 1
       --and hcpdt.receipt_no in ('cdg-c10924')
       --and hcpdt.pay_no='1401383'
       AND (   :p_order_no IS NULL
            OR (UPPER (hcpdt.order_no) = UPPER ( :p_order_no)))
       AND (   :p_voucher_no IS NULL
            OR (UPPER (hcpdt.voucher_no) = UPPER ( :p_voucher_no)));


------------------------------api-----------------------------------------------
--hpnret_co_pay_head_api
