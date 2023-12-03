select 
    t.Year,
    t.period,
    t.part_no,
    IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('DSCP', t.part_no) commo_grp_2,
    t.cost
from COST_PER_PART_TAB t
where 
  t.year = 2015 and
  t.period = 3 and
  IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('DSCP', t.part_no) in ('S-AC', 'S-COM', 'S-CTV', 'S-DVD', 'S-GEN', 'S-IPS', 
                                                                       'S-MC', 'S-OTS', 'S-OVN', 'S-REF', 'S-SWM', 'S-WM')
