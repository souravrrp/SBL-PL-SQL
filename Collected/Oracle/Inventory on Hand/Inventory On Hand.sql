select 
    --* 
    T.contract,
    T.part_no,
    T.location_no,
    sum(T.qty_onhand) qty_onhand
from IFSAPP.INVENTORY_PART_IN_STOCK t
group by t.contract, t.part_no, t.location_no
ORDER BY T.contract, T.part_no
