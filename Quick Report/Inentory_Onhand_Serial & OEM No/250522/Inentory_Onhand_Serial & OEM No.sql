select 
t.contract,t.part_no,t.serial_no,
(select o.oem_no from ifsapp.serial_oem_conn o where o.part_no=t.part_no and o.serial_no=t.serial_no) "OEM",
t.qty_onhand,t.qty_reserved,t.qty_in_transit
from ifsapp.inventory_part_in_stock t
where 
t.serial_no !='*'
and t.part_no != 'RCPT-BOOK'
and t.part_no != 'MUSHAK-11(KA)'
and t.qty_onhand > 0
and t.contract=upper('&SITE')
and t.part_no like '&Part_No'