--***** 246 Summary
select t.stat_year,
       t.stat_period_no,
       t.part_no,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.part_no)) product_family,
       sum(t.cf_balance) cf_balance
  from ifsapp.REP246_TAB t
 where t.stat_year = '&year_i'
   and t.stat_period_no = '&period'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', t.part_no) !=
       'RBOOK'
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', t.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', t.part_no) not like
       'S-%'
 group by t.stat_year, t.stat_period_no, t.part_no
 order by t.stat_year, t.stat_period_no, t.part_no
