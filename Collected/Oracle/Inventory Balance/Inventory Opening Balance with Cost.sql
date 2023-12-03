--***** Inventory Opening Balance with Cost
select t.year,
       t.period,
       t.site,
       t.part_no,
       sum(t.closing_bal) closing_bal,
       sum(t.in_transit) in_transit,
       avg(decode(t.location, 'NORMAL', t.cost, 0)) NORMAL_COST,
       sum(decode(t.location, 'TRANSIT', t.cost, 0)) TRANSIT_COST,
       sum(decode(t.location, 'REVERTS', t.cost, 0)) REVERTS_COST,
       sum(decode(t.location, 'DAMAGE', t.cost, 0)) DAMAGE_COST,
       max(t.cost) max_cost,
       avg(t.cost) avg_cost
  from INVENTORY_BALANCE t
 where t.year = '&year_i'
   and t.period = '&period'
   and t.part_no in ('RMAC-COMPSR-SAS12L90LVLGT',
                     'RMAC-COMPSR-SAS18L90LVLGT',
                     'RMAC-PANEL-SAS12L90LVLGT',
                     'RMAC-PANEL-SAS18L90LVLGT',
                     'RMAC-PARTS-SAS12L90LVLGT',
                     'RMAC-PARTS-SAS18L90LVLGT',
                     'RMAV-LED-28 -TCL',
                     'RMAV-LED-32-TCL-LCD-DEVIC',
                     'RMAV-PANEL-PARTS-28 -TCL',
                     'RMAV-PANEL-PARTS-32-TCL',
                     'RMAV-PARTS-SLE28D1620TC',
                     'RMAV-PARTS-SLE32A7000STC',
                     'RMAV-PARTS-SLE32D1200TC',
                     'RMAV-PARTS-SLE32D1202TC')
 group by t.year, t.period, t.site, t.part_no
 order by t.site, t.part_no, t.site, t.part_no
