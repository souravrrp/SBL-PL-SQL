/* Formatted on 4/2/2023 10:00:57 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.mixed_payment_tab mpt
 WHERE     1 = 1
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

SELECT *
  FROM ifsapp.mixed_payment_lump_sum_tab mplst;

SELECT *
  FROM ifsapp.mixed_payment_ledger_trans_tab mplt;

SELECT *
  FROM ifsapp.payment_per_mixed_payment_tab ppmpt;

--------------------------------------------------------------------------------
--MIXED_PAYMENT_API
