/* Formatted on 6/7/2023 5:07:34 PM (QP5 v5.381) */
SELECT d.contract,
       d.account_no,
       h.budget_book_id
           budget_book,
       ifsapp.customer_order_api.get_ord_gross_amount (d.account_no)
           cash_price,
       (SELECT ROUND (SUM (hprt.amount))
          FROM ifsapp.hpnret_pay_receipt_head_tab  hprht,
               ifsapp.hpnret_pay_receipt_tab       hprt
         WHERE     1 = 1
               AND hprht.receipt_no = hprt.receipt_no
               AND hprt.rowstate = 'Approved'
               AND hprht.account_no = d.account_no)
           paid_amount,
       --ifsapp.customer_order_api.Get_Total_Base_Charge__ (d.account_no) Charge_Amount,
       (SELECT SUM (coct.charge_amount)
          FROM ifsapp.customer_order_charge_tab coct
         WHERE     coct.order_no = d.account_no
               AND coct.charge_type = 'SERVICE CHARGE')
           charge_amount,
       (SELECT SUM (coct.charge_amount)
          FROM ifsapp.customer_order_charge_tab coct
         WHERE coct.order_no = d.account_no AND coct.charge_type = 'UCC')
           ecc_amount,
       /*ROUND (d.cash_price, 2)
           nsp,
       ifsapp.customer_order_line_api.get_total_tax_amount (
           d.account_no,
           d.ref_line_no,
           d.ref_rel_no,
           d.ref_line_item_no)
           tax_amount,
       (  d.cash_price
        + ifsapp.customer_order_line_api.get_total_tax_amount (
              d.account_no,
              d.ref_line_no,
              d.ref_rel_no,
              d.ref_line_item_no))
           total_rsp,
       ROUND (d.discount, 2)
           discount_percent,
       d.down_payment,
       d.install_amt,*/
       h.rowstate
           status,
       d.rowstate,
       TO_CHAR (d.sales_date, 'YYYY/MM/DD')
           salesdate,
       TO_CHAR (d.closed_date, 'YYYY/MM/DD')
           closedate
  --TO_CHAR (d.variated_date, 'YYYY/MM/DD') variation_date
  FROM ifsapp.hpnret_hp_dtl_tab  d
       INNER JOIN ifsapp.hpnret_hp_head_tab h ON d.account_no = h.account_no
 WHERE     h.rowstate = 'Closed'
       AND d.rowstate NOT IN ('Returned', 'CashConverted')
       AND d.reverted_date IS NULL
       AND d.line_no = 1
       AND ( :p_account_no IS NULL OR (d.account_no = :p_account_no))
       AND TRUNC (d.closed_date) BETWEEN NVL ( :p_date_from,
                                              TRUNC (d.closed_date))
                                     AND NVL ( :p_date_to,
                                              TRUNC (d.closed_date))