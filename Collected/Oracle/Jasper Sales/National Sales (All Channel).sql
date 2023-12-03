-- National Sales (All Channel)
SELECT L.SALES_DATE, L.Sales_Channel, L.SALES_PRICE
  FROM IFSAPP.SBL_JR_VW_ALL_CNL_SALES_SUMM L
 WHERE L.SALES_DATE BETWEEN to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
 --$P{From_Date} and $P{To_Date}
 ORDER BY L.SALES_DATE, L.Sales_Channel
