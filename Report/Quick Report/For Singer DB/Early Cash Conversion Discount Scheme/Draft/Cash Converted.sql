/* Formatted on 10/11/2022 4:18:36 PM (QP5 v5.381) */
  SELECT c.Account_No
             AS ACCOUNT_NO,
         TO_CHAR (c.VARIATED_DATE, 'YYYY/MM/DD')
             AS VARIATED_DATE,
         c.CATALOG_NO
             AS CATALOG_NO,
         c.QUANTITY
             AS QUANTITY,
           (-1)
         * customer_order_line_api.Get_Sale_Price_Total (c.Account_No,
                                                         c.REF_LINE_NO,
                                                         c.REF_REL_NO,
                                                         c.REF_LINE_ITEM_NO)
             AS "SALE_PRICE",
         NVL (
             (SELECT SUM (t.discount_amount)
                FROM cust_order_line_discount t
               WHERE     t.order_no = c.Account_No
                     AND t.line_no = c.REF_LINE_NO
                     AND t.rel_no = c.REF_REL_No
                     AND t.line_item_no = c.REF_LINE_ITEM_NO),
             0)
             AS "DISCOUNT",
           (-1)
         * customer_order_line_api.Get_Total_Tax_Amount (c.Account_No,
                                                         c.REF_LINE_NO,
                                                         c.REF_REL_NO,
                                                         c.REF_LINE_ITEM_NO)
             AS "TAX_PRICE",
         c.REFERENCE_CO
             AS REFERENCE_CO,
         p.DOM_AMOUNT
             AS LAST_PAYMENT_AMOUNT,
         (SELECT REPLACE (H.RECEIPT_NO, '-C', '-LP')
            FROM hpnret_co_pay_head_tab H,
                 (SELECT *
                    FROM hpnret_co_pay_dtl N1
                   WHERE n1.dom_amount <> 0) N
           WHERE     H.PAY_NO = N.PAY_NO
                 AND h.rowstate = 'Printed'
                 AND n.state = 'Paid'
                 AND N.ORDER_NO = C.REFERENCE_CO)
             AS "LPR_NO"
    FROM hpnret_hp_dtl_tab c,
         (SELECT *
            FROM hpnret_co_pay_dtl N1
           WHERE n1.dom_amount <> 0 AND n1.state IN ('Paid', 'PartiallyPaid'))
         p
   WHERE     p.ORDER_NO = c.REFERENCE_CO
         AND TRUNC (c.VARIATED_DATE) BETWEEN :P_start_date AND :P_end_date
         AND c.ROWSTATE IN ('CashConverted')
ORDER BY c.account_no, c.variated_date