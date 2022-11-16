/* Formatted on 10/12/2022 2:17:55 PM (QP5 v5.381) */
SELECT account_no,
       sales_date,
       catalog_no,
       reference_co,
       lpr_no,
       lpr_date,
       (CASE
            WHEN lpr_date - sales_date <= 60
            THEN
                1000
            WHEN lpr_date - sales_date >= 61 AND lpr_date - sales_date <= 150
            THEN
                500
            ELSE
                0
        END)    dis_vchr_amnt
  FROM (SELECT c.account_no                                AS account_no,
               c.sales_date                                sales_date,
               c.catalog_no                                AS catalog_no,
               c.reference_co                              AS reference_co,
               (SELECT REPLACE (h.receipt_no, '-C', '-LP')
                  FROM hpnret_co_pay_head_tab  h,
                       (SELECT *
                          FROM hpnret_co_pay_dtl n1
                         WHERE n1.dom_amount <> 0) n
                 WHERE     h.pay_no = n.pay_no
                       AND h.rowstate = 'Printed'
                       AND n.state = 'Paid'
                       AND (   :p_lpr_no IS NULL
                            OR REPLACE (h.receipt_no, '-C', '-LP') =
                               :p_lpr_no)
                       AND n.order_no = c.reference_co)    AS "LPR_NO",
               p.lump_sum_trans_date                       lpr_date
          FROM hpnret_hp_dtl_tab  c,
               (SELECT *
                  FROM hpnret_co_pay_dtl N1
                 WHERE     n1.dom_amount <> 0
                       AND n1.state IN ('Paid', 'PartiallyPaid')) p
         WHERE     p.order_no = c.reference_co
               AND c.rowstate IN ('CashConverted'))
 WHERE     1 = 1
       AND ( :p_lpr_no IS NULL OR lpr_no = :p_lpr_no)
       AND TRUNC (lpr_date) BETWEEN NVL ( :p_date_from, TRUNC (lpr_date))
                                AND NVL ( :p_date_to, TRUNC (lpr_date));