SELECT
    SDI.CUSTOMER_ID,
         sdi.NAME CUSTOMER_NAME,
    trunc(avg(H.ARR_MON),2) AVG_ARR_MON ,
    trunc(sum(H.ARR_AMT),2) SUM_ARR_AMT ,
    trunc(avg(H.DEL_MON),2) AVG_DEL_MON ,
    H.RED_DEL,
    trunc(sum(H.ACT_OUT_BAL),2) SUM_ACT_OUT_BAL
FROM IFSAPP.HPNRET_FORM249_ARREARS_TAB H, ifsapp.customer_info_tab sdi 
WHERE H.ACT_OUT_BAL > 0 AND
  H.YEAR = $P{YEAR}  AND
  H.PERIOD = $P{MONTH}  AND
  SDI.CUSTOMER_ID = H.CUSTOMER AND
  H.RED_DEL = 'Y'
  group by SDI.CUSTOMER_ID,sdi.NAME,H.RED_DEL
  order by sdi.NAME