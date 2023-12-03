select 
    t.stat_year,
    t.stat_period_no,
    t.contract,
    t.part_no,
    t.branch,
    t.sales sale,
    t.exch_in_cash exincash,
    t.exch_in_hire exinhire,
    t.revert_qty revert,    
    t.exch_out_cash exoutcash,
    t.exch_out_hire exouthire,
    t.sale_reverse sale_return,
    t.revert_rev "REVERSE"
from REP246_TAB t
where 
  t.stat_year = '&year_i' and
  t.stat_period_no = '&period' and
  --*** All Shops
  t.Contract not in ('BWHW', 'KWHW', 'RWHW', 'TWHW', 'CMWH', 'SPWH', 'SWHW', 'CTGW', 'APWH', 'SYWH', 'MYWH', 
    'BLSP', 'BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC', 
    'WSMO', 'SWSS', 'SAOS', 'JWSS', 'SCSM', 'SAPM', 'SESM', 'SAVF', 'SCAF')
order by t.contract, t.part_no
