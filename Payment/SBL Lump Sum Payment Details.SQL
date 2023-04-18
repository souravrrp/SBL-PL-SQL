/* Formatted on 3/29/2023 12:39:56 PM (QP5 v5.381) */
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
   WHERE     1 = 1
         AND TRUNC (t.lump_sum_trans_date) BETWEEN NVL (
                                                       :p_date_from,
                                                       TRUNC (
                                                           t.lump_sum_trans_date))
                                               AND NVL (
                                                       :p_date_to,
                                                       TRUNC (
                                                           t.lump_sum_trans_date))
         AND (   :p_bank_id IS NULL
              OR (ifsapp.mixed_payment_api.Get_Short_Name (company,
                                                           mixed_payment_id) =
                  :p_bank_id))
         AND ( :p_customer_no IS NULL OR (t.payer_identity = :p_customer_no))
ORDER BY t.lump_sum_trans_date