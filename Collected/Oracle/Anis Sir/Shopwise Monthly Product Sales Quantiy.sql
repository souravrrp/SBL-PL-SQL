select 
    --count(*)
    s.year,
    s.period,
    s.shop_code,
    s.sales_part,
    IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Code('SCOM', s.sales_part)) Brand,
    IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', s.sales_part)) product_family,
    IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM', s.sales_part)) commodity_group,
    sum(s.cash_units) total_cash_units,
    sum(s.cash_value) total_cash_value,
    sum(s.hire_units) total_hire_units,
    sum(s.net_hire_cash_value) total_hire_value,
    --sum(s.cash_units) + sum(s.hire_units) total_units
    sum(s.reverts_units) total_revert_units,
    sum(s.reverts_value) total_revert_value,
    sum(s.revert_reverse_units) total_revert_reverse_units,
    --(sum(s.cash_units) + sum(s.hire_units) - sum(s.reverts_units) + sum(s.revert_reverse_units)) total_units
    sum(s.revert_reverse_value) total_revert_reverse_value
from ifsapp.sbl_direct_sales_details_tab /*ifsapp.temp_direct_sales_tab*/ s
where 
  s.year = '&year_i' and
  s.period <= '&period' and
  s.catalog_type != 'KOMP' and
  --s.shop_code = 'DUTB' --and
  s.shop_code not in ('BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC') --and
  --s.sales_part like '%PHS%'
group by s.year, s.period, s.shop_code, s.sales_part /*IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Code('SCOM', s.sales_part))*/
ORDER BY s.year, s.period, s.shop_code--, s.sales_part


--*****
/*select 
    --*
    t.year,
    t.period,
    t.shop_code,
    t.inventory_part,
    t.sales_part,
    t.product_family,
    t.commodity2,
    t.total_hire_units,
    t.total_cash_units
from HPNRET_DIRECT_SALES t
where --t.shop_code = 'DUTB'
order by t.year, t.period, t.sales_part*/
