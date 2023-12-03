select m.SITE,
       m.area_code,
       m.district_code,
       sum(m.SALES_QUANTITY) TOTAL_SALES_QUANTITY,
       sum(m.SALES_PRICE) TOTAL_SALES_PRICE,
       sum(m.VAT) TOTAL_VAT,
       sum(m.RSP) TOTAL_RSP
  from ifsapp.SBL_VW_MULTI_BRAND_SALES m
 where m.SALES_DATE between
       to_date('&YEAR_I' || '/' || '&PERIOD' || '/1', 'yyyy/mm/dd') and
       LAST_DAY(to_date('&YEAR_I' || '/' || '&PERIOD' || '/1', 'yyyy/mm/dd'))
 group by m.SITE, m.area_code, m.district_code
 order by 2, 3, 1
