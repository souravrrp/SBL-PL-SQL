select 
    --*
    --i.contract site, 
    (i.part_no) inventory_part, 
    MAX(i.second_commodity) commodity_group_2
from IFSAPP.INVENTORY_PART i
where i.contract <> 'SCOM'
GROUP BY I.part_no, I.second_commodity
