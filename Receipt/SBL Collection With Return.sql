/* Formatted on 3/30/2023 10:01:06 AM (QP5 v5.381) */
  SELECT CONTRACT,
         ACCOUNT_NO,
         ORIGINAL_ACC_NO,
         ORIGINAL_SALES_DATE,
         RECEIPT_NO,
         SUM (AMOUNT)     AMOUNT,
         PAYMENT_DATE,
         PAY_METHOD,
         ROWSTATE
    FROM (SELECT hprt.contract,
                 hprht.account_no,
                 ifsapp.hpnret_hp_head_api.Get_Original_Acc_No (
                     hprht.account_no,
                     1)                       original_acc_no,
                 ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date (
                     hprht.account_no,
                     1)                       original_sales_date,
                 hprt.receipt_no,
                 hprt.amount,
                 TRUNC (hprt.voucher_date)    payment_date,
                 hprt.pay_method,
                 hprt.rowstate
            FROM ifsapp.hpnret_pay_receipt_head_tab hprht,
                 ifsapp.hpnret_pay_receipt_tab     hprt
           WHERE     1 = 1
                 AND hprt.receipt_no = hprht.receipt_no
                 AND (   :p_shop_code IS NULL
                      OR (UPPER (hprt.contract) = UPPER ( :p_shop_code)))
                 AND TRUNC (hprt.voucher_date) BETWEEN NVL (
                                                           :p_date_from,
                                                           TRUNC (
                                                               hprt.voucher_date))
                                                   AND NVL (
                                                           :p_date_to,
                                                           TRUNC (
                                                               hprt.voucher_date))
          UNION
          SELECT hprt.contract,
                 hprht.account_no,
                 ifsapp.hpnret_hp_head_api.Get_Original_Acc_No (
                     hprht.account_no,
                     1)                original_acc_no,
                 ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date (
                     hprht.account_no,
                     1)                original_sales_date,
                 hprt.receipt_no,
                 (-1) * hprt.amount    amount,
                 sri.date_returned     payment_date,
                 hprt.pay_method,
                 hprt.rowstate
            FROM ifsapp.hpnret_pay_receipt_head_tab hprht,
                 ifsapp.hpnret_pay_receipt_tab     hprt,
                 ifsapp.sbl_return_info            sri
           WHERE     1 = 1
                 AND hprt.receipt_no = hprht.receipt_no
                 AND hprht.account_no = sri.order_no
                 AND hprt.contract = sri.contract
                 AND (   :p_shop_code IS NULL
                      OR (UPPER (hprt.contract) = UPPER ( :p_shop_code)))
                 AND TRUNC (sri.date_returned) BETWEEN NVL (
                                                           :p_date_from,
                                                           TRUNC (
                                                               sri.date_returned))
                                                   AND NVL (
                                                           :p_date_to,
                                                           TRUNC (
                                                               sri.date_returned)))
GROUP BY CONTRACT,
         ACCOUNT_NO,
         ORIGINAL_ACC_NO,
         ORIGINAL_SALES_DATE,
         RECEIPT_NO,
         PAYMENT_DATE,
         PAY_METHOD,
         ROWSTATE