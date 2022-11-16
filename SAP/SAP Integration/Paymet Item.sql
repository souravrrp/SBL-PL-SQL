/* Formatted on 10/20/2022 9:57:24 AM (QP5 v5.381) */
  SELECT c.part_no
             line_items,
         p.payment_method,
         p.order_no,
         (SELECT it.invoice_id
            FROM ifsapp.invoice_tab it
           WHERE it.voucher_no_ref = p.voucher_no)
             invoice_no,
         p.dom_amount
             payment_value,
         p.currency_code
             currency,
         p.order_no
             cash_aacount,
         p.cheque_no
             cheque_document_number,
         (SELECT REPLACE (h.receipt_no, '-C', '-LP')
            FROM hpnret_co_pay_head_tab h,
                 (SELECT *
                    FROM hpnret_co_pay_dtl n1
                   WHERE n1.dom_amount <> 0) n
           WHERE     h.pay_no = n.pay_no
                 AND h.rowstate = 'Printed'
                 AND n.state = 'Paid'
                 AND n.order_no = c.reference_co)
             AS lpr_no,
         p.dom_amount
             AS last_payment_amount,
         NVL (
             (SELECT SUM (t.discount_amount)
                FROM cust_order_line_discount t
               WHERE     t.order_no = c.account_no
                     AND t.line_no = c.ref_line_no
                     AND t.rel_no = c.ref_rel_no
                     AND t.line_item_no = c.ref_line_item_no),
             0)
             AS discount_value,
           -----------------------------------------------------------------------
           --c.account_no AS account_no,
           ----TO_CHAR (c.variated_date, 'YYYY/MM/DD') AS variated_date,
           ----c.catalog_noAS catalog_no,
           ----c.quantity AS quantity,
           (-1)
         * customer_order_line_api.get_sale_price_total (c.account_no,
                                                         c.ref_line_no,
                                                         c.ref_rel_no,
                                                         c.ref_line_item_no)
             AS "SALE_PRICE",
           (-1)
         * customer_order_line_api.get_total_tax_amount (c.account_no,
                                                         c.ref_line_no,
                                                         c.ref_rel_no,
                                                         c.ref_line_item_no)
             AS "TAX_PRICE",
         c.reference_co
             AS reference_co,
         c.sales_date
             actual_sale_date,
         p.lump_sum_trans_date
             lpr_date--,c.*
                     ,
         p.*
    FROM hpnret_hp_dtl_tab c,
         (SELECT *
            FROM hpnret_co_pay_dtl N1
           WHERE n1.dom_amount <> 0 AND n1.state IN ('Paid', 'PartiallyPaid'))
         p
   WHERE p.order_no = c.reference_co 
   --AND TRUNC (c.VARIATED_DATE) BETWEEN :P_start_date AND :P_end_date
   --AND c.rowstate IN ('CashConverted')
   AND p.order_no = 'CBB-R20382'
ORDER BY c.account_no, c.variated_date;