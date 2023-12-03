SELECT h.SHOP_CODE,
       h.YEAR,
       h.PERIOD,
       COUNT(*) as Active_Account,
       sum(h.ACT_OUT_BAL) as Total_Receivable
       --sum(h.ARR_AMT) as Arrea_Amount
  from IFSAPP.hpnret_form249_arrears_tab h
 where H.YEAR = '&YEAR_A'
   AND H.PERIOD = '&MONTH_A'
   AND H.ACT_OUT_BAL > 0
 GROUP BY H.SHOP_CODE, h.YEAR, h.PERIOD
