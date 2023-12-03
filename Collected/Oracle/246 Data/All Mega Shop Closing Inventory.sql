--***** All Mega Shop Closing Inventory
select t.stat_year,
       t.stat_period_no,
       t.contract,
       (select s.area_code
          from SHOP_DTS_INFO s
         where s.shop_code = t.contract) area_code,
       (select s.district_code
          from SHOP_DTS_INFO s
         where s.shop_code = t.contract) district_code,
       t.part_no,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.part_no)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 t.part_no)) commodity_group2,
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
       to_char(t.rowversion, 'MM/DD/YYYY') rowversion
  from ifsapp.REP246_TAB t
 where t.stat_year = '&year_i'
   and t.stat_period_no = '&period'
      --*** All Megashops
   and t.Contract in ('CJTB',
                      'DGNB',
                      'DINB',
                      'DKBB',
                      'DMBB',
                      'DMRB',
                      'DPLB',
                      'DRRB',
                      'DRSB',
                      'DUTB',
                      'JESB',
                      'KSRB',
                      'MLVB',
                      'SCHB')
 order by t.stat_year, t.stat_period_no, to_number((select s.district_code
                      from SHOP_DTS_INFO s
                     where s.shop_code = t.contract)), t.contract, t.part_no
