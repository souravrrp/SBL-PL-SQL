/* Formatted on 4/2/2023 10:40:19 AM (QP5 v5.381) */
SELECT CONCAT (mpt.voucher_type_ref, mpt.voucher_no_ref)    receipt_no,
       mpt.voucher_date_ref                                 payment_date,
       SUBSTRB (Mixed_Payment_Man_Posting_API.Get_Code_Part (
                    'A',
                    mplst.company,
                    mplst.mixed_payment_id,
                    mplst.lump_sum_trans_id),
                1,
                20)                                         "Account",
       ifsapp.account_api.Get_Description (
           'SBL',
           SUBSTRB (Mixed_Payment_Man_Posting_API.Get_Code_Part (
                        'A',
                        mplst.company,
                        mplst.mixed_payment_id,
                        mplst.lump_sum_trans_id),
                    1,
                    20))                                    "Description",
       mplst.curr_amount                                    "Amount",
       mpt.rowstate                                         status,
       mpt.short_name                                       bcb
  FROM ifsapp.mixed_payment_tab mpt, ifsapp.mixed_payment_lump_sum_tab mplst
 WHERE     1 = 1
       AND mpt.mixed_payment_id = mplst.mixed_payment_id
       AND (   :p_bcb_no IS NULL
            OR (UPPER (mpt.short_name) = UPPER ( :p_bcb_no)))
       AND TRUNC (mpt.voucher_date_ref) BETWEEN NVL (
                                                    :p_date_from,
                                                    TRUNC (
                                                        mpt.voucher_date_ref))
                                            AND NVL (
                                                    :p_date_to,
                                                    TRUNC (
                                                        mpt.voucher_date_ref));