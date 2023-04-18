/* Formatted on 3/29/2023 3:09:25 PM (QP5 v5.381) */
SELECT hprt.contract,
       hprht.account_no,
       ifsapp.hpnret_hp_head_api.get_original_acc_no (hprht.account_no, 1)
           original_acc_no,
       ifsapp.hpnret_hp_head_api.get_original_sales_date (hprht.account_no,
                                                          1)
           original_sales_date,
       hprt.receipt_no,
       hprt.amount,
       TRUNC (hprt.voucher_date)
           payment_date,
       hprt.pay_method,
       hprt.rowstate
  FROM ifsapp.hpnret_pay_receipt_head_tab  hprht,
       ifsapp.hpnret_pay_receipt_tab       hprt
 WHERE     1 = 1
       AND hprt.receipt_no = hprht.receipt_no
       AND (   :p_receipt_no IS NULL
            OR (UPPER (hprt.receipt_no) = UPPER ( :p_receipt_no)))
       AND (   :p_account_no IS NULL
            OR (UPPER (hprht.account_no) = UPPER ( :p_account_no)))
       AND TRUNC (hprt.voucher_date) BETWEEN NVL ( :p_date_from,
                                               TRUNC (hprt.voucher_date))
                                      AND NVL ( :p_date_to,
                                               TRUNC (hprt.voucher_date))