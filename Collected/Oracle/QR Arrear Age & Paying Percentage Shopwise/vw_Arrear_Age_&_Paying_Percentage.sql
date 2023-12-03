create or replace view sbl_vw_arrearage_and_paying
as
SELECT 
    v1.YEAR,
    v1.PERIOD,
    (select s.area_code from SHOP_DTS_INFO s where s.shop_code = v1.shop_code) area_code,
    (select s.district_code from SHOP_DTS_INFO s where s.shop_code = v1.shop_code) district_code,
    v1.SHOP_CODE,    
    v1.Active_Account, 
    v1.Total_Receivable,
    nvl(v2.Arr_AC, 0) Arrear_Account,
    v1.Arrear_Amount,
    round((v1.Arrear_Amount/v1.Total_Receivable)*100,2) ARREARAGE,
    nvl(v3.Arr_not_paying, 0) Arr_not_paying,
    (v1.Active_Account - nvl(v2.Arr_AC, 0) + nvl(v3.Arr_not_paying, 0)) PAYING_ACCOUNT,
    round(((v1.Active_Account - nvl(v2.Arr_AC, 0) + nvl(v3.Arr_not_paying, 0)) / v1.Active_Account) * 100, 2) PAYING
from
  --Periodic shopwise active account, total receivable, and arrear amount
  (SELECT 
      h.YEAR,
      h.PERIOD,
      h.SHOP_CODE,    
      COUNT(*) as Active_Account, 
      sum(h.ACT_OUT_BAL) as Total_Receivable,
      sum(h.ARR_AMT) as Arrear_Amount
  from
    IFSAPP.hpnret_form249_arrears_tab h
  where 
    --H.YEAR='&YEAR' AND 
    --H.PERIOD='&MONTH' AND
    H.ACT_OUT_BAL > 0
  GROUP BY h.YEAR, h.PERIOD, H.SHOP_CODE) v1

left join

  --Periodic shopwise arrear account
  (SELECT 
      h.year,
      h.period,
      h.shop_code,
      nvl(COUNT(*),0) AS Arr_AC
  FROM 
    IFSAPP.hpnret_form249_arrears_tab h
  WHERE 
    --H.YEAR = '&YEAR' AND 
    --H.PERIOD = '&MONTH' AND 
    H.ARR_AMT > 0
  GROUP BY h.year, h.period, h.shop_code) v2

on
v1.year = v2.year and
v1.period = v2.period and
v1.shop_code = v2.shop_code

left join

  --Periodic shopwise arrear account no paying
  (SELECT
      h.year,
      h.period,
      h.shop_code,
      nvl(COUNT(*),0) as Arr_not_paying 
  FROM 
    IFSAPP.hpnret_form249_arrears_tab h
  WHERE 
    --H.YEAR = '&YEAR' AND 
    --H.PERIOD = '&MONTH' AND 
    H.ARR_AMT > 0 AND 
    H.COLLECTION >= H.MONTHLY_PAY
  GROUP BY h.year, h.period, H.SHOP_CODE) v3

on
v1.year = v3.year and
v1.period = v3.period and
v1.shop_code = v3.shop_code

order by v1.YEAR, v1.PERIOD, area_code, district_code, v1.SHOP_CODE
