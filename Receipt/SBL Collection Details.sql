/* Formatted on 3/30/2023 9:11:16 AM (QP5 v5.381) */
SELECT hprt.contract,
       hprht.account_no,
       ifsapp.hpnret_hp_head_api.Get_Original_Acc_No (hprht.account_no, 1)
           original_acc_no,
       ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date (hprht.account_no,
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
       AND (   :p_shop_code IS NULL
            OR (UPPER (hprt.contract) = UPPER ( :p_shop_code)))
       AND TRUNC (hprt.voucher_date) BETWEEN NVL ( :p_date_from,
                                                  TRUNC (hprt.voucher_date))
                                         AND NVL ( :p_date_to,
                                                  TRUNC (hprt.voucher_date))