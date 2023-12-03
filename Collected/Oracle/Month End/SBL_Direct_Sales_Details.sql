--Cash Sales Data with positive accounts of HP Variations
select 
    --count(*)
    s.year,
    s.period,
    s.shop_code,
    s.salesman_code,
    s.order_no,
    s.hp_type,
    s.bb_type,
    s.free_item,
    s.state,
    s.sales_part,
    s.part_no,
    s.catalog_type,
    s.act_group,
    s.mc_accounts,
    s.cd_accounts,
    s.group_accounts,
    s.normal_accounts,
    s.special_accounts,
    s.net_hire_cash_value,
    s.hire_value,
    s.list_value,
    s.first_payment,
    (select 
        max(c.base_sale_unit_price) base_sale_unit_price
      from customer_order_line_tab c        
      where c.order_no = s.order_no and c.catalog_no = s.sales_part
      group by c.order_no, c.catalog_no) base_sale_unit_price,
    s.hire_units,
    s.cash_units,
    s.cash_value,
    s.revert_reverse_units,
    s.revert_reverse_value,
    s.reverts_units,
    s.reverts_value,
    s.no_sanasuma_hp_units,
    s.val_sanasuma_hp_lines,
    s.no_suraksha_hp_units,
    s.val_suraksha_hp_lines,
    s.no_sanasuma_cash_lines,
    s.val_sanasuma_cash_accounts,
    s.no_suraksha_cash_units,
    s.val_suraksha_cash_units,
    s.special_discount_value,
    s.promotional_discount_value,
    s.revt_cash_price,
    s.revtrev_cash_price,
    s.rowversion,
    /*s.customer_no,
    s.customer_name,
    --CUSTOMER_INFO_COMM_METHOD_API.Get_Value(s.customer_no, 1) tel_no,
    s.co_cash_conv,
    s.co_remarks,
    s.fee_code,
    s.fee_rate,
    s.tax_amount*/--,
    Customer_Order_Api.Get_Customer_No(s.order_no) Customer_No,
    customer_info_api.Get_Name(Customer_Order_Api.Get_Customer_No(s.order_no)) Customer_Name,
    (select h.cash_conv from  HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) cash_conv, 
    (select h.remarks from HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) co_remarks,
    (select c.fee_code
      from CUSTOMER_ORDER_LINE_TAB c 
      where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1) fee_code,
    STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
      from CUSTOMER_ORDER_LINE_TAB c 
      where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1)) Fee_Rate,
    (s.cash_value + s.special_discount_value + s.promotional_discount_value) * (STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
        from CUSTOMER_ORDER_LINE_TAB c 
        where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1))/100) Tax_amount
from /*temp_direct_sales_tab*/ sbl_direct_sales_details_tab s
where 
  s.year = '&year_i' and
  s.period = '&period' and
  s.catalog_type != 'KOMP' AND
  --s.sales_part = 'SRWF-SLCT01'
  substr(s.order_no,4,2) = '-R' --and
  --s.order_no = 'SCS-R873'
ORDER BY S.YEAR, S.PERIOD, S.SHOP_CODE, S.ORDER_NO



--Hire Sales Data
select 
    --sum(s.net_hire_cash_value)
    --count(*)
    s.year,
    s.period,
    s.shop_code,
    s.salesman_code,
    s.order_no,
    s.hp_type,
    s.bb_type,
    s.free_item,
    s.state,
    s.sales_part,
    s.part_no,
    s.catalog_type,
    s.act_group,
    s.mc_accounts,
    s.cd_accounts,
    s.group_accounts,
    s.normal_accounts,
    s.special_accounts,
    s.net_hire_cash_value,
    s.hire_value,
    s.list_value,
    s.first_payment,
    s.hire_units,
    s.cash_units,
    s.cash_value,
    s.revert_reverse_units,
    s.revert_reverse_value,
    s.reverts_units,
    s.reverts_value,
    s.no_sanasuma_hp_units,
    s.val_sanasuma_hp_lines,
    s.no_suraksha_hp_units,
    s.val_suraksha_hp_lines,
    s.no_sanasuma_cash_lines,
    s.val_sanasuma_cash_accounts,
    s.no_suraksha_cash_units,
    s.val_suraksha_cash_units,
    s.special_discount_value,
    s.promotional_discount_value,
    s.revt_cash_price,
    s.revtrev_cash_price,
    s.rowversion,
    /*s.customer_no,
    s.customer_name,
    s.co_cash_conv,
    s.co_remarks,
    s.fee_code,
    s.fee_rate,
    s.tax_amount*/--,
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
from /*temp_direct_sales_tab*/ sbl_direct_sales_details_tab s
where 
  s.year = '&year_i' and
  s.period = '&period' and
  s.catalog_type != 'KOMP' AND
  substr(s.order_no,4,2) = '-H' and
  s.state not in ('Reverted', 'RevertReversed')  --'CashConverted', 'Reverted', 'RevertReversed' 
ORDER BY S.YEAR, S.PERIOD, S.SHOP_CODE, S.ORDER_NO
