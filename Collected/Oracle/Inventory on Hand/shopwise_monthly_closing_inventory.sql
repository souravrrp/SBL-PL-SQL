select 
    --*/*COUNT(*)*/
    t.stat_year year,
    t.stat_period_no period,
    t.contract shop_code,
    t.part_no,
    /*t.branch,
    t.ad,*/
    t.bf_balance inventory_balance--,
    --t.cf_balance,
  from REP246_TAB t
  where t.stat_year = '&year_i' and
    t.stat_period_no = '&period' and
    --t.Contract in ('BWHW', 'KWHW', 'RWHW', 'TWHW', 'CMWH', 'SPWH', 'SWHW', 'CTGW', 'APWH', 'SYWH') AND
    --t.Contract in ('CJTB', 'DGNB', 'DMRB', 'DKBB', 'DRRB', 'DPLB', 'DINB', 'JESB', 'MLVB', 'SCHB')
    t.part_no like 'TL%'
order by t.contract, t.part_no
