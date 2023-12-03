select t.part_no, t.description, T.PART_PRODUCT_FAMILY
from INVENTORY_PART_TAB t
where t.part_no like '%HRST-%' AND 
T.CONTRACT = 'SCOM' --AND
--T.PART_PRODUCT_FAMILY = 'STAND'
GROUP BY T.PART_NO
