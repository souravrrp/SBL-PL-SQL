SELECT COST from INVENT_ONLINE_COST_TAB i 
where i.contract='&SHOP_CODE' 
and i.part_no='&PART_NO'
and year=extract(year from (trunc(TO_DATE('&DATE', 'YYYY/MM/DD'), 'MM')-1))
and period=extract(month from (trunc(TO_DATE('&DATE', 'YYYY/MM/DD'), 'MM')-1))
/*(to_date(sysdate,'mm-dd-yy'),'mm')*/
--trunc(sysdate, 'MM')

select trunc(TO_DATE('&DATE', 'YYYY/MM/DD'), 'MM')-1 from dual
TO_DATE('&DATE', 'YYYY/MM/DD')
