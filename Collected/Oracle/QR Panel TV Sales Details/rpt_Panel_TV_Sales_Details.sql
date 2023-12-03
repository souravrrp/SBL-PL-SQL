select *
  from IFSAPP.SBL_VW_PANEL_TV_PROMO s
 where s.SALES_DATE between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
