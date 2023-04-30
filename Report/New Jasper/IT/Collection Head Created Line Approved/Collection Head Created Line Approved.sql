/* Formatted on 4/27/2023 12:54:23 PM (QP5 v5.381) */
SELECT hprt.contract site,
       hprht.account_no,
       ifsapp.hpnret_hp_head_api.Get_Original_Sales_Date (hprht.account_no,
                                                          1)    sales_date,
       hprt.receipt_no,
       hprt.amount,
       TRUNC (hprt.voucher_date)                                payment_date,
       hprht.rowstate                                           head_status,
       hprt.rowstate                                            line_status
  FROM ifsapp.hpnret_pay_receipt_head_tab  hprht,
       ifsapp.hpnret_pay_receipt_tab       hprt
 WHERE     1 = 1
       AND hprt.receipt_no = hprht.receipt_no
       AND hprht.rowstate = 'Created'
       AND hprt.rowstate = 'Approved'
       AND (   :p_shop_code IS NULL
            OR (UPPER (hprt.contract) = UPPER ( :p_shop_code)))
       AND TRUNC (hprt.voucher_date) BETWEEN NVL ( :p_date_from,
                                                  TRUNC (hprt.voucher_date))
                                         AND NVL ( :p_date_to,
                                                  TRUNC (hprt.voucher_date))