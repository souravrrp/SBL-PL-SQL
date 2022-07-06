/* Formatted on 7/4/2022 10:38:44 AM (QP5 v5.381) */
SELECT c.short_name     Account_Name,
       c.balance_date,
       c.CALCULATED_CREDIT,
       c.CALCULATED_DEBIT,
       c.CALCULATED_BALANCE,
       a.ACCOUNT_IDENTITY,
       a.DESCRIPTION
  FROM cash_account_balance_tab c, CASH_ACCOUNT_TAB a
 WHERE     a.short_name = c.short_name
       AND c.balance_date = TO_DATE ('&End_Date', 'YYYY/MM/DD')