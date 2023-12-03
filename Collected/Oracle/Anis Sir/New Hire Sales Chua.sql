--New Hire Sale
select
    --count(*)
    s.year,
    s.period,
    s.shop_code,
    s.order_no,
    s.free_item,
    s.state,
    s.sales_part,
    s.catalog_type,
    IFSAPP.INVENTORY_PRODUCT_FAMILY_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(s.shop_code, s.sales_part)) product_family,
    IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(s.shop_code, s.sales_part)) commodity_group,
    s.net_hire_cash_value,
    s.hire_value,
    s.list_value,
    s.first_payment,
    s.hire_units,
    s.special_discount_value,
    s.promotional_discount_value,
    --h.year,
    --h.period,
    --h.shop_code,
    --h.original_acct_no,
    --h.acct_no,
    --h.product_code,
    TO_CHAR(H.ACTUAL_SALES_DATE, 'YYYY/MM/DD') ACTUAL_SALES_DATE,
    TO_CHAR(H.SALES_DATE, 'YYYY/MM/DD') SALES_DATE,
    H.NORMAL_CASH_PRICE,
    H.HIRE_CASH_PRICE,
    --H.HIRE_PRICE,
    H.AMOUNT_FINANCED,
    H.MONTHLY_PAY,
    --H.FIRST_PAY,
    H.DOWN_PAYMENT,
    H.LOC,
    H.TOTAL_UCC,
    H.ACT_OUT_BAL,
    TO_CHAR(H.CASH_CONVERSION_ON_DATE, 'YYYY/MM/DD') CASH_CONVERSION_ON_DATE    
from 
  sbl_direct_sales_details_tab s,
  HPNRET_FORM249_ARREARS_TAB H
where 
  s.year = h.year and
  s.period = h.period and
  s.shop_code = h.shop_code and
  s.order_no = h.Original_Acct_No and
  s.sales_part = h.product_code and
  s.year = '&year_i' and
  s.period <= '&period' and
  s.catalog_type != 'KOMP' AND
  substr(s.order_no,4,2) = '-H' and
  s.state not in ('CashConverted', 'Reverted', 'RevertReversed', 'Returned')  --'CashConverted', 'Reverted', 'RevertReversed' 
ORDER BY S.YEAR, S.PERIOD, S.SHOP_CODE, S.ORDER_NO
