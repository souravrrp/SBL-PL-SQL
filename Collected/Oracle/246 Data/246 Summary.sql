select t.stat_year,
       t.stat_period_no,
       t.part_no,
       ifsapp.inventory_part_api.Get_Description('SCOM', t.part_no) "DESCRIPTION",
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.part_no)) product_family,
       sum(t.bf_balance) bf_balance,
       sum(t.adj_dr) adj_dr,
       sum(t.adj_cr) adj_cr,
       sum(t.debit_note) debit_note,
       sum(t.exch_in_cash) exch_in_cash,
       sum(t.exch_in_hire) exch_in_hire,
       sum(t.revert_qty) revert_qty,
       sum(t.sale_reverse) sale_reverse,
       sum(t.trf_in) trf_in,
       sum(t.trfc_in) trfc_in,
       sum(t.direct_dr) direct_dr,
       sum(t.other_rec) other_rec,
       sum(t.credit_note) credit_note,
       sum(t.exch_out_cash) exch_out_cash,
       sum(t.exch_out_hire) exch_out_hire,
       sum(t.trf_out) trf_out,
       sum(t.trfc_out) trfc_out,
       sum(t.other_iss) other_iss,
       sum(t.revert_rev) revert_rev,
       sum(t.sales) sales,
       --sum(t.ad_sales) ad_sales,
       sum(t.cf_balance) cf_balance,
       sum(t.revert_bal) revert_bal --,
       --sum(t.school_stock) school_stock,
       --sum(t.ad_stock) ad_stock
  from IFSAPP.REP246_TAB t
 where t.stat_year = '&year_i'
   and t.stat_period_no = '&period'
   and t.part_no like '&part_no'
 group by t.stat_year, t.stat_period_no, t.part_no
 order by t.part_no
