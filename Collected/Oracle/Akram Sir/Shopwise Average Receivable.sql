SELECT h.SHOP_CODE,
       h.YEAR,
       '1 to &period' period_range,
       nvl(round(sum(h.ACT_OUT_BAL), 2), 0) Total_Receivable,
       round(nvl(round(sum(h.ACT_OUT_BAL), 2), 0) / '&period', 2) as Average_Receivable
  from IFSAPP.hpnret_form249_arrears_tab h
 where H.YEAR = '&YEAR_A'
   AND H.PERIOD <= '&period'
   AND H.ACT_OUT_BAL > 0
 GROUP BY H.SHOP_CODE, H.YEAR
 ORDER BY 1
