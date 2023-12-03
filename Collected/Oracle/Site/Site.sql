select h.site_id shop_code, 
    (SELECT l.description FROM HPNRET_LEVEL_TAB l where l.level_id = 
      (select higher_level from hpnret_level_hierarchy_tab where level_id = 
      (select h.higher_level from hpnret_level_hierarchy_tab where level_id = h.level_id))) area_code, 
    (SELECT substr(l.description, 10, 2/*instr(l.description, ' District') - 1*/) 
      FROM HPNRET_LEVEL_TAB l where l.level_id = h.higher_level) district_code
from IFSAPP.hpnret_level_hierarchy_tab h
where h.site_id is not null and 
h.higher_level in (select l.level_id from HPNRET_LEVEL_TAB l where l.description
not in ('Corporate Sub Channel', 'Service Sub Channel', 'Warehouse Sub Channel', 'Whole Sale Management Office', 'Wholesale Channel Old'))
order by area_code, district_code, shop_code

--Corporate Sub Channel
--Service Sub Channel
--Warehouse Sub Channel
--Whole Sale Management Office
--Wholesale Channel Old
