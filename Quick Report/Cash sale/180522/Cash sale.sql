/* Formatted on 5/18/2022 9:38:30 AM (QP5 v5.381) */
  SELECT pay_m.ACCOUNT_NO,
         MAX (pay_d.VOUCHER_DATE)     Last_pay_dt,
         SUM (pay_d.AMOUNT)           New_collection
    FROM ifsapp.hpnret_pay_receipt_tab     pay_d,
         ifsapp.HPNRET_PAY_RECEIPT_head_TAB pay_m
   WHERE pay_m.RECEIPT_NO = pay_d.RECEIPT_NO AND pay_m.ACCOUNT_NO = 's'
GROUP BY pay_m.ACCOUNT_NO