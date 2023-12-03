select count(*)/*t.year,
    t.period,
    t.part_no,
    t.cost,
    to_char(t.rowversion, 'MM/DD/YYYY') rowversion,
    t.company_closing,
    t.company_transit,
    t.revert_qty*/
from COST_PER_PART_TAB t
where t.year = 2014 and
  t.period = 1
