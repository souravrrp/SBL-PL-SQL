/* Formatted on 7/4/2022 11:34:36 AM (QP5 v5.381) */
  SELECT TO_CHAR (t.lump_sum_trans_date, 'YYYY/MM/DD')
             "Transaction Date",
         t.payer_identity
             "Customer ID",
         ifsapp.customer_info_api.Get_Name (t.payer_identity)
             "Customer Name",
         ifsapp.mixed_payment_api.Get_Voucher_No_Ref (t.company,
                                                      t.mixed_payment_id)
             "Voucher No",
         t.text
             "Narration",
         ifsapp.mixed_payment_api.Get_Short_Name (company, mixed_payment_id)
             "Bank ID",
         t.curr_amount
             "Payment Amount"
    FROM ifsapp.mixed_payment_lump_sum_tab t
   WHERE     t.lump_sum_trans_date BETWEEN TO_DATE ('&fromdate', 'YYYY/MM/DD')
                                       AND TO_DATE ('&todate', 'YYYY/MM/DD')
         AND ifsapp.mixed_payment_api.Get_Short_Name (company,
                                                      mixed_payment_id) LIKE
                 '&bankid'
         AND t.payer_identity LIKE '&customerid'
ORDER BY t.lump_sum_trans_date