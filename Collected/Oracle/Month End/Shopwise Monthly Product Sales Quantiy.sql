select 
    --count(*)
    s.year,
    s.period,
    s.shop_code,
    s.sales_part,
    IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Code(s.shop_code, s.sales_part)) Brand,
    IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(s.shop_code, s.sales_part)) product_family,
    IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(s.shop_code, s.sales_part)) commodity_group,
    sum(s.cash_units) total_cash_units,
    sum(s.hire_units) total_hire_units,
    sum(s.reverts_units) total_reverts_units,
    sum(s.revert_reverse_units) total_revert_reverse_units
from ifsapp.sbl_direct_sales_details_tab s
where 
  s.year = '&year_i' and
  --s.period = '&period' and
  s.period between '&period_from' and '&period_to' and
  s.catalog_type != 'KOMP' and
  s.sales_part like 'HWPHS-%'
group by s.year, s.period, s.shop_code, s.sales_part
ORDER BY s.year, s.period, S.SHOP_CODE, s.sales_part
