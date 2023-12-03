select 
    --count(*)
    s.year,
    s.period,
    s.sales_part,
    IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Code('SCOM', s.sales_part)) Brand,
    IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', s.sales_part)) product_family,
    IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM', s.sales_part)) commodity_group,
    --sum(s.cash_units) total_cash_units,
    --sum(s.hire_units) total_hire_units,
    sum(s.cash_units) + sum(s.hire_units) total_units
from ifsapp.sbl_direct_sales_details_tab s
where 
  s.year = '&year_i' and
  s.period <= '&period' and
  s.catalog_type != 'KOMP' and
  s.shop_code not in ('BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC')
group by s.year, s.period, s.sales_part
ORDER BY s.year, s.period, s.sales_part