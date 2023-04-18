/* Formatted on 3/29/2023 10:15:30 AM (QP5 v5.381) */
SELECT cabt.short_name     account_name,
       cabt.balance_date,
       cabt.calculated_credit,
       cabt.calculated_debit,
       cabt.calculated_balance,
       cat.account_identity,
       cat.description
  FROM ifsapp.cash_account_balance_tab cabt, ifsapp.cash_account_tab cat
 WHERE     cat.short_name = cabt.short_name
       AND TRUNC (cabt.balance_date) BETWEEN NVL ( :p_date_from,
                                                  TRUNC (cabt.balance_date))
                                         AND NVL ( :p_date_to,
                                                  TRUNC (cabt.balance_date));