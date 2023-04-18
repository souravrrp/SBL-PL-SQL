/* Formatted on 3/19/2023 3:45:40 PM (QP5 v5.381) */
--------------------------------Cash Sales--------------------------------------
SELECT *
  FROM ifsapp.hpnret_co_pay_head_tab hcpht
 WHERE     1 = 1
       --AND hcpht.receipt_no IN ('CDG-C10924')
       --and hcpht.pay_no='1401383'
       AND (   :p_receipt_no IS NULL
            OR (UPPER (hcpht.receipt_no) = UPPER ( :p_receipt_no)));

SELECT *
  FROM ifsapp.hpnret_co_pay_dtl_tab hcpdt
 WHERE     1 = 1
       --AND hcpdt.receipt_no IN ('CDG-C10924')
       --and hcpdt.pay_no='1401383'
       AND (   :p_order_no IS NULL
            OR (UPPER (hcpdt.order_no) = UPPER ( :p_order_no)))
       AND (   :p_VOUCHER_NO IS NULL
            OR (UPPER (hcpdt.voucher_no) = UPPER ( :p_VOUCHER_NO)));

--------------------------------HP Sales----------------------------------------
SELECT *
  FROM ifsapp.hpnret_pay_receipt_head_tab hprht
 WHERE     1 = 1
       --AND hprht.receipt_no IN ('CDG-C10924')
       --and hprht.pay_no='1401383'
       AND (   :p_order_no IS NULL OR (UPPER (hprht.account_no) = UPPER ( :p_order_no)))
       AND (   :p_receipt_no IS NULL OR (UPPER (hprht.receipt_no) = UPPER ( :p_receipt_no)));

SELECT *
  FROM ifsapp.hpnret_pay_receipt_tab hprt
 WHERE     1 = 1
       --AND hprt.receipt_no IN ('CDG-C10924')
       --and hprt.pay_no='1401383'
       AND (   :p_receipt_no IS NULL
            OR (UPPER (hprt.receipt_no) = UPPER ( :p_receipt_no)));

------------------------------api-----------------------------------------------
--hpnret_co_pay_head_api
