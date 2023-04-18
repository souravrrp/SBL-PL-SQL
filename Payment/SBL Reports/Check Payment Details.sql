/* Formatted on 3/19/2023 2:22:19 PM (QP5 v5.381) */
  SELECT TO_CHAR (t.payment_date, 'YYYY/MM/DD')
             "Payment Date",
         t.identity
             "Customer ID",
         t.name
             "Customer Name",
         SUBSTR (t.ledger_item_id, 0, INSTR (t.ledger_item_id, '#') - 1)
             "Check No",
         t.voucher_text
             "Narration",
         t.voucher_no
             "Voucher No",
         TO_CHAR (t.fully_paid_voucher_date, 'YYYY/MM/DD')
             "Voucher Date",
         TO_CHAR (t.clear_date, 'YYYY/MM/DD')
             "Clear Date",
         t.full_curr_amount
             "Amount",
         t.cash_account
             "Bank Account ID",
         t.state
             "Status"
    FROM ifsapp.CHECK_LEDGER_ITEM t
   WHERE     1 = 1
         AND t.voucher_no=NVL(:P_voucher_no,t.voucher_no)
         --AND ( :p_customerid IS NULL OR (t.identity = :p_customerid))
         --and t.payment_date between $P{FROM_DATE} and $P{TO_DATE}
         --t.payment_date,t.identity,t.name,t.ledger_item_id
         AND TRUNC (t.fully_paid_voucher_date) BETWEEN NVL ( :p_date_from,
                                                 TRUNC (t.fully_paid_voucher_date))
                                        AND NVL ( :p_date_to,
                                                 TRUNC (t.fully_paid_voucher_date))
         --AND TRUNC (t.payment_date) BETWEEN NVL ( :p_date_from, TRUNC (t.payment_date)) AND NVL ( :p_date_to, TRUNC (t.payment_date))
ORDER BY t.payment_date, t.voucher_no