/* Formatted on 4/2/2023 10:38:31 AM (QP5 v5.381) */
  SELECT a.identity                                        customer_no,
         ifsapp.customer_info_api.get_name (a.identity)    customer_name,
         a.account_no,
         a.account_rev,
         a.receipt_no,
         a.receipt_date,
         a.rowstate,
         (  SUM (NVL (b.amount, 0))
          + SUM (NVL (b.other_pay_amt, 0))
          + SUM (NVL (b.discount, 0)))                     collection_amount
    FROM ifsapp.hpnret_pay_receipt_head_tab a,
         ifsapp.hpnret_pay_dtl_receipt_tab b,
         ifsapp.hpnret_pay_dtl_tab         c
   WHERE     a.company = b.company
         AND a.receipt_no = b.receipt_no
         AND a.account_no = b.account_no
         AND a.account_rev = b.account_rev
         AND b.company = c.company
         AND b.account_no = c.account_no
         AND b.account_rev = c.account_rev
         AND b.line_no = c.line_no
         AND b.pay_rev = c.pay_rev
         AND b.pay_line_no = c.pay_line_no
         --AND   a.account_no       = '2701186'
         --AND   a.account_rev      = account_rev_
         AND (   :p_receipt_no IS NULL
              OR (UPPER (a.receipt_no) = UPPER ( :p_receipt_no)))
         AND TRUNC (a.receipt_date) BETWEEN NVL ( :p_date_from,
                                                 TRUNC (a.receipt_date))
                                        AND NVL ( :p_date_to,
                                                 TRUNC (a.receipt_date))
         AND a.rowstate NOT IN ('Created', 'Cancelled')
         AND c.hpnret_installment_type NOT IN ('1',
                                               '2',
                                               '3',
                                               '5')
GROUP BY a.identity,
         a.account_no,
         a.account_rev,
         a.receipt_no,
         a.receipt_date,
         a.rowstate;