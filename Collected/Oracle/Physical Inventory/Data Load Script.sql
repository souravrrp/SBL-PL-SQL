-- Data Load 246 & in-transit
insert into SBL_INVENTORY_COUNTING_DTS
  (CATALOG_NO,
   SITE,
   QTY_ONHAND,
   REVERT_QTY,
   REVERT_REV,
   REVERT_BAL,
   QTY_IN_TRANSIT)
  select t.part_no,
         t.contract,
         t.cf_balance,
         t.revert_qty,
         t.revert_rev,
         t.revert_bal,
         c.in_transit
    from ifsapp.REP246_TAB t
   inner join ifsapp.INVENT_ONLINE_COST_TAB c
      on t.stat_year = c.year
     and t.stat_period_no = c.period
     and t.contract = c.contract
     and t.part_no = c.part_no
   where t.stat_year = '&year_i'
     and t.stat_period_no = '&period'
     and t.cf_balance > 0
   order by t.contract, t.part_no;
commit;
