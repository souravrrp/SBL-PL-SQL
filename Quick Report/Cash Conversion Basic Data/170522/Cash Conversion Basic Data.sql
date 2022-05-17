/* Formatted on 5/17/2022 9:39:08 AM (QP5 v5.381) */
  SELECT c.product_code,
         IFSAPP.SALES_PART_API.Get_Catalog_Desc ('SCOM', c.product_code)
             product_desc,
         c.eff_from,
         c.eff_to,
         c.cre_date,
         c.user_id,
         c.from_days,
         c.to_days,
         c.rowstate
    FROM ifsapp.HPNRET_CASH_CON_DTL_TAB c
   WHERE     c.product_code LIKE '&product_code'
         AND c.eff_from = TO_DATE ('&from_date', 'YYYY/MM/DD')
         AND c.eff_to = TO_DATE ('&to_date', 'YYYY/MM/DD')
ORDER BY c.product_code