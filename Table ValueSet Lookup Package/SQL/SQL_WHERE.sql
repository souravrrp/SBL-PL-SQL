select
TO_CHAR(OOH.ORDERED_DATE,'DD-MON-YYYY HH24:MI:SS') ORDERED_DATE,
from
dual tab
where 1=1
and ((:p_org_id is null and tab.org_id in (83,84,85,605))  or (tab.org_id=:p_org_id))
and (:p_status is null or (ool.status = :p_status))
and (:p_region_name_exclude is null or (dbm.region_name <> :p_region_name_exclude))
and trunc(tab.date) between nvl(:p_date_from,trunc(tab.date)) and nvl(:p_date_to,trunc(tab.date))
and tab.code !='SCI'   --<>'SCI'
and tab.transport_mode in ('Company Truck')
-----------------------------------SUBSTR---------------------------------------
--AND substr(DODL.ITEM_NUMBER,0,3)='TLH'
-----------------------------------Date-----------------------------------------
--AND TO_CHAR(TMD.TRUCK_LOADING_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2018/MAR/18 06:00:00' AND '2018/MAR/18 14:00:00'
--AND TO_CHAR(tab.MOV_ORDER_DATE,'DD-MON-RR')='31-DEC-18'
--AND TO_CHAR(tab.MOV_ORDER_DATE,'MON-RR')='DEC-18'
--AND TO_CHAR(tab.MOV_ORDER_DATE,'RRRR')='2018'
--AND DOH.DO_DATE BETWEEN '01-JAN-2010' and '30-APR-2018'
and not exists
                (select 1
                   from xxakg_del_ord_do_lines dol1
                  where dol1.order_line_id = sol.line_id
                        and dol1.org_id = sol.org_id);