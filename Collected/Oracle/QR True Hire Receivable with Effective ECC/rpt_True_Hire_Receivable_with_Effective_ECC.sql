select K.SHOP_CODE,
       K.YEAR,
       K.PERIOD as "MONTH",
       round(K.Total_Receivable) "RECEIVABLE AMOUNT",
       K.Arrea_Amount as "ARREAR AMOUNT",
       K.Active_Account as "ACTIVE ACCOUNT",
       nvl(T.Arr_AC, 0) as "ARREAR ACCOUNT",
       round(K.present_value, 2) present_value,
       round(K.actual_ucc, 2) actual_ucc,
       round(K.effective_ecc, 2) effective_ecc
  FROM (SELECT h.SHOP_CODE,
               h.YEAR,
               h.PERIOD,
               COUNT(*) as Active_Account,
               sum(h.ACT_OUT_BAL) as Total_Receivable,
               sum(h.ARR_AMT) as Arrea_Amount,
               sum(h.present_value) present_value,
               sum(h.actual_ucc) actual_ucc,
               sum(h.effective_ecc) effective_ecc
          from IFSAPP.hpnret_form249_arrears_tab h
         where H.YEAR = '&YEAR_A'
           AND H.PERIOD = '&MONTH_A'
           AND H.ACT_OUT_BAL > 0
           and h.cash_conversion_on_date <
               last_day(to_date('&YEAR_A' || '/' || '&MONTH_A' || '/01',
                                'YYYY/MM/DD'))
         GROUP BY H.SHOP_CODE, h.YEAR, h.PERIOD) K,
       (SELECT SHOP_CODE, nvl(COUNT(*), 0) AS Arr_AC
          FROM IFSAPP.hpnret_form249_arrears_tab h
         WHERE H.YEAR = '&YEAR_A'
           AND H.PERIOD = '&MONTH_A'
           AND H.ARR_AMT > 0
           and h.cash_conversion_on_date <
               last_day(to_date('&YEAR_A' || '/' || '&MONTH_A' || '/01',
                                'YYYY/MM/DD'))
         GROUP BY shop_code) T
 WHERE K.SHOP_CODE = T.SHOP_CODE(+)
 order by K.SHOP_CODE
