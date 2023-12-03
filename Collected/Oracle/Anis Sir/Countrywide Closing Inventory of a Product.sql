select 
    --*
    --COUNT(*)
    t.stat_year,
    t.stat_period_no,
    --t.contract,
    t.part_no,
    /*t.branch,
    t.ad,
    t.bf_balance,
    t.adj_dr,
    t.adj_cr,
    t.debit_note,
    t.exch_in_cash,
    t.exch_in_hire,
    t.revert_qty,
    t.sale_reverse,
    t.trf_in,
    t.trfc_in,
    t.direct_dr,
    t.other_rec,
    t.credit_note,
    t.exch_out_cash,
    t.exch_out_hire,
    t.trf_out,
    t.trfc_out,
    t.other_iss,
    t.revert_rev,
    t.sales,
    t.ad_sales,*/
    sum(t.cf_balance) cf_balance--,
    /*t.revert_bal,
    t.school_stock,
    t.ad_stock,
    to_char(t.rowversion, 'MM/DD/YYYY') rowversion*/
from REP246_TAB t
where 
  t.stat_year = '&year_i' and
  t.stat_period_no = '&period' and
  t.part_no like '%DVD-%' and
  t.cf_balance > 0
group by t.stat_year, t.stat_period_no, t.part_no
ORDER BY T.PART_NO
