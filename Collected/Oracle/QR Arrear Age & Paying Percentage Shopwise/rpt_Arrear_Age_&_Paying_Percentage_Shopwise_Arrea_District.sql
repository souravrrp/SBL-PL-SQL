select K.area_code,
      K.district_code,
      K.SHOP_CODE,
      K.YEAR,
      K.PERIOD as "MONTH",
      round(K.Total_Receivable) "RECEIVABLE",
      K.Arrea_Amount  as "ARREAR",
      round((K.Arrea_Amount/K.Total_Receivable)*100,2) as "ARREARAGE",
      K.Active_Account,
      nvl(T.Arr_AC,0) as "ARREAR ACCOUNT" ,
      (K.Active_Account-nvl(T.Arr_AC,0)+ nvl(T.Arr_not_paying,0)) as "PAYING ACCOUNT",
      round(((K.Active_Account-nvl(T.Arr_AC,0)+ nvl(T.Arr_not_paying,0))/K.Active_Account)*100,2)as "PAYING" --,
      --T.Arr_not_paying  
  FROM
    (SELECT h.SHOP_CODE,
        sdi.area_code,
        sdi.district_code,
        h.YEAR,
        h.PERIOD,
        COUNT(*) as Active_Account, 
        sum(h.ACT_OUT_BAL) as Total_Receivable,
        sum(h.ARR_AMT) as Arrea_Amount
    from IFSAPP.hpnret_form249_arrears_tab h
      inner join SHOP_DTS_INFO sdi
      on
        h.shop_code = sdi.shop_code
    where H.YEAR='&YEAR'
        AND H.PERIOD='&MONTH'
        AND H.ACT_OUT_BAL>0
    GROUP BY H.SHOP_CODE, sdi.area_code, sdi.district_code, h.YEAR, h.PERIOD) K,
    (SELECT v1.SHOP_CODE,
          v1.Arr_AC,
          v2.Arr_not_paying
      from
        (SELECT SHOP_CODE,
              nvl(COUNT(*),0) AS Arr_AC 
          FROM IFSAPP.hpnret_form249_arrears_tab h
          WHERE H.YEAR = '&YEAR' 
              AND H.PERIOD = '&MONTH'
              AND H.ARR_AMT > 0
          GROUP BY shop_code) v1,        
        (SELECT  SHOP_CODE,
              nvl(COUNT(*),0) as Arr_not_paying 
          FROM IFSAPP.hpnret_form249_arrears_tab h
          WHERE H.YEAR = '&YEAR'
              AND H.PERIOD = '&MONTH'
              AND H.ARR_AMT > 0
              AND H.COLLECTION >= H.MONTHLY_PAY
          GROUP BY H.SHOP_CODE)V2
      where v1.shop_code=v2.shop_code(+))T
  WHERE 
  K.SHOP_CODE=T.SHOP_CODE(+)
  order by K.area_code, K.district_code, K.SHOP_CODE
