--Cash Sales Data with positive accounts of HP Variations
select 
    s.*,
    (select 
        max(c.base_sale_unit_price) base_sale_unit_price
      from customer_order_line_tab c        
      where c.order_no = s.order_no and c.catalog_no = s.sales_part
      group by c.order_no, c.catalog_no) base_sale_unit_price,
    Customer_Order_Api.Get_Customer_No(s.order_no) Customer_No,
    customer_info_api.Get_Name(Customer_Order_Api.Get_Customer_No(s.order_no)) Customer_Name,
    (select h.cash_conv from  HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) cash_conv, 
    (select h.remarks from HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) remarks,
    (select c.fee_code
      from CUSTOMER_ORDER_LINE_TAB c 
      where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1) fee_code,
    STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
      from CUSTOMER_ORDER_LINE_TAB c 
      where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1)) Fee_Rate,
    (s.cash_value + s.special_discount_value + s.promotional_discount_value) * (STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
        from CUSTOMER_ORDER_LINE_TAB c 
        where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1))/100) Tax_amount
from temp_direct_sales_tab s
where 
  s.year = '&year_i' and
  s.period = '&period' and
  s.catalog_type != 'KOMP' AND
  substr(s.order_no,4,2) = '-R'
ORDER BY S.SHOP_CODE, S.ORDER_NO



--Hire Sales Data
select 
    --sum(s.net_hire_cash_value)
    s.*,
    Customer_Order_Api.Get_Customer_No(s.order_no) Customer_No,
    customer_info_api.Get_Name(Customer_Order_Api.Get_Customer_No(s.order_no)) Customer_Name,
    (select c.fee_code
      from CUSTOMER_ORDER_LINE_TAB c 
      where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1) fee_code,
    STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
        from CUSTOMER_ORDER_LINE_TAB c 
        where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1)) Fee_Rate,
    (s.net_hire_cash_value + s.special_discount_value + s.promotional_discount_value) * (STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
        from CUSTOMER_ORDER_LINE_TAB c 
        where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1))/100) Tax_amount
from temp_direct_sales_tab s
where 
  s.year = '&year_i' and
  s.period = '&period' and
  s.catalog_type != 'KOMP' AND
  substr(s.order_no,4,2) = '-H' and
  s.state not in ('Reverted', 'RevertReversed') --'CashConverted', 'Reverted', 'RevertReversed' 
ORDER BY S.SHOP_CODE, S.ORDER_NO
