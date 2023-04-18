/* Formatted on 3/29/2023 2:20:38 PM (QP5 v5.381) */
  SELECT t.stat_year,
         t.stat_period_no,
         t.contract,
         (SELECT s.area_code
            FROM shop_dts_info s
           WHERE s.shop_code = t.contract)
             area_code,
         (SELECT s.district_code
            FROM shop_dts_info s
           WHERE s.shop_code = t.contract)
             district_code,
         t.part_no,
         ifsapp.inventory_product_code_api.get_description (
             ifsapp.inventory_part_api.get_part_product_code ('SCOM',
                                                              t.part_no))
             brand,
         ifsapp.inventory_product_family_api.get_description (
             ifsapp.inventory_part_api.get_part_product_family ('SCOM',
                                                                t.part_no))
             product_family,
         ifsapp.commodity_group_api.get_description (
             ifsapp.inventory_part_api.get_second_commodity ('SCOM', t.part_no))
             commodity_group2,
         t.branch,
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
         t.ad_sales,
         t.cf_balance,
         t.revert_bal,
         t.school_stock,
         t.ad_stock,
         TO_CHAR (t.rowversion, 'MM/DD/YYYY')
             rowversion
    FROM ifsapp.rep246_tab t
   WHERE     1 = 1
         AND ( :p_year IS NULL OR (UPPER (t.stat_year) = UPPER ( :p_year)))
         AND (   :p_period IS NULL
              OR (UPPER (t.stat_period_no) = UPPER ( :p_period)))
ORDER BY t.stat_year,
         t.stat_period_no,
         TO_NUMBER ((SELECT s.district_code
                       FROM shop_dts_info s
                      WHERE s.shop_code = t.contract)),
         t.contract,
         t.part_no