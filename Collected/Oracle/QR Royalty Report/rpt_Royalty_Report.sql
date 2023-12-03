select r.*
  from IFSAPP.SBL_ROYALTY_REPORT r
 where r.year = '&year'
   and r.period = '&period'
 order by r.sales_group, r.PRODUCT_CODE
