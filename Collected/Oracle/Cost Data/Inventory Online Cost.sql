--cost data for Sir
SELECT i.year,
    i.period,
    i.contract,
    i.part_no,
    i.cost,
    i.in_transit,
    to_char(i.rowversion, 'MM/DD/YYYY') rowversion
FROM INVENT_ONLINE_COST_TAB I
WHERE I.YEAR = 2014 AND
  I.PERIOD = 1
