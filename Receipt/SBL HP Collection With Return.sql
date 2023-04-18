/* Formatted on 3/29/2023 2:50:01 PM (QP5 v5.381) */
  SELECT CONTRACT,
         ACCOUNT_NO,
         ORIGINAL_ACC_NO,
         RECEIPT_NO,
         SUM (AMOUNT)     AMOUNT,
         PAYMENT_DATE,
         PAY_METHOD,
         ROWSTATE
    FROM (SELECT c.contract,
                 c.account_no,
                 c.original_acc_no,
                 c.receipt_no,
                 c.amount     amount,
                 c.payment_date,
                 c.pay_method,
                 c.rowstate
            FROM ifsapp.sbl_collection_info c
           WHERE     1 = 1
                 AND (   :p_shop_code IS NULL
                      OR (UPPER (c.contract) = UPPER ( :p_shop_code)))
                 AND TRUNC (c.payment_date) BETWEEN NVL (
                                                        :p_date_from,
                                                        TRUNC (c.payment_date))
                                                AND NVL (
                                                        :p_date_to,
                                                        TRUNC (c.payment_date))
          UNION
          SELECT r.contract,
                 r.order_no          account_no,
                 c.original_acc_no,
                 c.receipt_no,
                 (-1) * c.amount     amount,
                 r.date_returned,
                 c.pay_method,
                 c.rowstate
            FROM ifsapp.sbl_return_info r, ifsapp.sbl_collection_info c
           WHERE     r.order_no = c.account_no
                 AND r.contract = c.contract
                 AND (   :p_shop_code IS NULL
                      OR (UPPER (c.contract) = UPPER ( :p_shop_code)))
                 AND TRUNC (r.date_returned) BETWEEN NVL (
                                                         :p_date_from,
                                                         TRUNC (
                                                             r.date_returned))
                                                 AND NVL (
                                                         :p_date_to,
                                                         TRUNC (
                                                             r.date_returned)))
GROUP BY CONTRACT,
         ACCOUNT_NO,
         ORIGINAL_ACC_NO,
         RECEIPT_NO,
         PAYMENT_DATE,
         PAY_METHOD,
         ROWSTATE