/* Formatted on 10/12/2022 9:46:54 AM (QP5 v5.381) */
SELECT account_no,
       sales_date,
       catalog_no,
       reference_co,
       lpr_no,
       lpr_date,
       (CASE
            WHEN lpr_date - sales_date <= 90
            THEN
                1000
            WHEN lpr_date - sales_date >= 90 AND lpr_date - sales_date <= 180
            THEN
                500
            ELSE
                0
        END)    dis_vchr_amnt
  FROM (SELECT c.account_no                                AS account_no,
               c.sales_date                                sales_date, --actual_sale_date
               c.catalog_no                                AS catalog_no,
               --c.quantity                                  AS quantity,
               --customer_order_line_api.get_sale_price_total ( c.account_no, c.ref_line_no, c.ref_rel_no, c.ref_line_item_no)                     AS "SALE_PRICE",
               --NVL ( (SELECT SUM (t.discount_amount) FROM cust_order_line_discount t WHERE     t.order_no = c.account_no AND t.line_no = c.ref_line_no AND t.rel_no = c.ref_rel_no AND t.line_item_no = c.ref_line_item_no), 0) AS "DISCOUNT",
               c.reference_co                              AS reference_co,
               --p.dom_amount                                AS last_payment_amount,
               (SELECT REPLACE (h.receipt_no, '-C', '-LP')
                  FROM hpnret_co_pay_head_tab  h,
                       (SELECT *
                          FROM hpnret_co_pay_dtl n1
                         WHERE n1.dom_amount <> 0) n
                 WHERE     h.pay_no = n.pay_no
                       AND h.rowstate = 'Printed'
                       AND n.state = 'Paid'
                       AND n.order_no = c.reference_co)    AS "LPR_NO",
               p.lump_sum_trans_date                       lpr_date
          --,c.*
          --,p.*
          FROM hpnret_hp_dtl_tab  c,
               (SELECT *
                  FROM hpnret_co_pay_dtl N1
                 WHERE     n1.dom_amount <> 0
                       AND n1.state IN ('Paid', 'PartiallyPaid')) p
         WHERE     p.order_no = c.reference_co
               --AND TRUNC (c.VARIATED_DATE) BETWEEN :P_start_date AND :P_end_date
               --AND p.order_no = 'CBB-R20382'
               AND c.rowstate IN ('CashConverted'))
 WHERE 1 = 1                                      --AND LPR_NO = 'CBB-LP18017'
             AND TRUNC (lpr_date) BETWEEN :P_start_date AND :P_end_date;