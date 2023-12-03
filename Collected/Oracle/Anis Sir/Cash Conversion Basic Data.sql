select c.product_code,
       IFSAPP.SALES_PART_API.Get_Catalog_Desc('SCOM', c.product_code) product_desc,
       c.eff_from,
       c.eff_to,
       c.cre_date,
       c.user_id,
       c.from_days,
       c.to_days,
       c.rowstate
  from HPNRET_CASH_CON_DTL_TAB c
 where c.product_code like '&product_code'
      --and (c.to_days = '&days'
   and c.eff_from = to_date('&from_date', 'YYYY/MM/DD')
   and c.eff_to = to_date('&to_date', 'YYYY/MM/DD')
 order by c.product_code
