select v.YEAR,
       v.PERIOD,
       v.area_code,
       v.district_code,
       v.SHOP_CODE,
       v.Active_Account,
       v.Total_Receivable,
       v.Arrear_Account,
       v.Arrear_Amount,
       v.ARREARAGE,
       v.PAYING_ACCOUNT,
       v.PAYING
  from ifsapp.sbl_vw_arrearage_and_paying v
 where v.YEAR = '&year_i'
   and v.PERIOD = '&period'
   and v.area_code like '&area_code'
