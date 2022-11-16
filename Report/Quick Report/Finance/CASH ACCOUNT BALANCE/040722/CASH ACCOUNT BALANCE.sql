/* Formatted on 7/4/2022 10:31:42 AM (QP5 v5.381) */
  SELECT DISTINCT a.short_name               Account_Name,
                  a.ACCOUNT_IDENTITY,
                  a.DESCRIPTION,
                  (SELECT c.balance_date
                     FROM ifsapp.cash_account_balance_tab c
                    WHERE     c.balance_date =
                              TO_DATE ('&End_Date', 'YYYY/MM/DD')
                          AND c.short_name = a.short_name
                          AND c.COMPANY = a.COMPANY
                          AND ROWNUM = 1)    BALANCE_DATE,
                  (SELECT c.CALCULATED_CREDIT
                     FROM ifsapp.cash_account_balance_tab c
                    WHERE     c.balance_date =
                              TO_DATE ('&End_Date', 'YYYY/MM/DD')
                          AND c.short_name = a.short_name
                          AND c.COMPANY = a.COMPANY
                          AND ROWNUM = 1)    CALCULATED_CREDIT,
                  (SELECT c.CALCULATED_DEBIT
                     FROM ifsapp.cash_account_balance_tab c
                    WHERE     c.balance_date =
                              TO_DATE ('&End_Date', 'YYYY/MM/DD')
                          AND c.short_name = a.short_name
                          AND c.COMPANY = a.COMPANY
                          AND ROWNUM = 1)    CALCULATED_DEBIT,
                  (SELECT c.CALCULATED_BALANCE
                     FROM ifsapp.cash_account_balance_tab c
                    WHERE     c.balance_date =
                              TO_DATE ('&End_Date', 'YYYY/MM/DD')
                          AND c.short_name = a.short_name
                          AND c.COMPANY = a.COMPANY
                          AND ROWNUM = 1)    BALANCE
    FROM ifsapp.CASH_ACCOUNT_TAB a
ORDER BY a.ACCOUNT_IDENTITY