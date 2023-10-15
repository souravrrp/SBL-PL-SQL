------------------------------------------SQL-----------------------------------
-----OR Null
AND (l.order_no = $P{ORDER_NUMBER} or  $P{ORDER_NUMBER}='')
AND (l.order_no = $P{ORDER_NUMBER} or  $P{ORDER_NUMBER} IS NULL)


------------------------------------Jasper PARAMETER----------------------------
------STRING1
($P{ORDER_NUMBER}.isEmpty() || $P{ORDER_NUMBER} == null) ? "and 1=1" : "and l.order_no = $P{ORDER_NUMBER}"

------DATE0
AND TRUNC(l.date_entered)  BETWEEN $P{FROM_DATE} and $P{TO_DATE}

------DATE1
AND EXTRACT(YEAR FROM l.date_entered) BETWEEN $P{FROM_YEAR} AND $P{TO_YEAR}
AND EXTRACT(MONTH FROM l.date_entered) BETWEEN $P{START_PERIOD} AND $P{END_PERIOD}
------DATE2
 ($P{fromDate}.isEmpty() || $P{fromDate} == null) 
 && ($P{toDate}.isEmpty() || $P{toDate} == null) 
 ? "and 1=1" : "and (cast(requestDate as date) between (cast("+$P{fromDate}+" as date)) and (cast("+$P{toDate}+" as date)))"
 
 --Like
 AND t.identity LIKE '%$P!{CUSTOMER_NUMBER}%'