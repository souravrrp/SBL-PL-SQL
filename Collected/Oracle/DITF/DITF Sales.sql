select 
  --*
  t.year,
  t.period,
  t.shop_code,
  t.order_no,
  TO_CHAR(CUSTOMER_ORDER_API.Get_Date_Entered(T.ORDER_NO), 'YYYY/MM/DD') DATE_ENTERED,
  TO_CHAR(CUSTOMER_ORDER_API.Get_Wanted_Delivery_Date(T.ORDER_NO), 'YYYY/MM/DD') Wanted_Delivery_Date,
  t.state,
  t.sales_part,
  t.catalog_type,
  t.cash_units,
  t.cash_value,
  t.special_discount_value,
  t.promotional_discount_value,
  t.tax_amount
from SBL_DIRECT_SALES_DETAILS_TAB t
where t.shop_code = 'DITF'
ORDER BY T.ORDER_NO
