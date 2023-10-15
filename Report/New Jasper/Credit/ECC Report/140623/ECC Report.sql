SELECT CONTRACT,
       ACCOUNT_NO,
       BUDGET_BOOK,
       CASH_PRICE,
       PAID_AMOUNT,
       CHARGE_AMOUNT,
       (PAID_AMOUNT - (CASH_PRICE + CHARGE_AMOUNT))     ECC_AMOUNT,
       STATUS,
       ROWSTATE,
       SALESDATE,
       CLOSEDATE
  FROM (SELECT d.contract,
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
               (SELECT SUM (coct.charge_amount)
                  FROM ifsapp.customer_order_charge_tab coct
                 WHERE     coct.order_no = d.account_no
                       AND coct.charge_type = 'SERVICE CHARGE')
                   charge_amount,
               (SELECT SUM (coct.charge_amount)
                  FROM ifsapp.customer_order_charge_tab coct
                 WHERE     coct.order_no = d.account_no
                       AND coct.charge_type = 'UCC')
                   ecc,
               h.rowstate
                   status,
               d.rowstate,
               TO_CHAR (d.sales_date, 'YYYY/MM/DD')
                   salesdate,
               TO_CHAR (d.closed_date, 'YYYY/MM/DD')
                   closedate
          FROM ifsapp.hpnret_hp_dtl_tab  d
               INNER JOIN ifsapp.hpnret_hp_head_tab h
                   ON d.account_no = h.account_no
         WHERE     h.rowstate = 'Closed'
               AND d.rowstate NOT IN ('Returned', 'CashConverted')
               AND d.reverted_date IS NULL
               AND d.line_no = 1
               AND TRUNC(d.closed_date)  BETWEEN $P{FROM_DATE} and $P{TO_DATE})
 WHERE SIGN (PAID_AMOUNT - (CASH_PRICE + CHARGE_AMOUNT)) = 1