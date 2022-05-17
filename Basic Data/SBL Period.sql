/* Formatted on 4/5/2022 11:00:28 AM (QP5 v5.381) */
SELECT ay.opening_balances,
       ay.accounting_year,
       ay.year_status,
       ap.description,
       ap.year_end_period
  --,ay.*
  --,ap.*
  FROM ifsapp.acc_year ay, ifsapp.accounting_period ap
 WHERE     1 = 1
       AND ay.accounting_year = ap.accounting_year
       AND ay.company = ap.company;

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.acc_year ay;

SELECT *
  FROM ifsapp.accounting_period ap;