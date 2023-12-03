--***** Start Cash Sales Data Transfer *****
insert into SBL_DIRECT_SALES_DETAILS_TAB(
    year,
    period,
    shop_code,
    salesman_code,
    order_no,
    hp_type,
    bb_type,
    free_item,
    state,
    sales_part,
    part_no,
    catalog_type,
    act_group,
    mc_accounts,
    cd_accounts,
    group_accounts,
    normal_accounts,
    special_accounts,
    net_hire_cash_value,
    hire_value,
    list_value,
    first_payment,
    hire_units,
    cash_units,
    cash_value,
    revert_reverse_units,
    revert_reverse_value,
    reverts_units,
    reverts_value,
    no_sanasuma_hp_units,
    val_sanasuma_hp_lines,
    no_suraksha_hp_units,
    val_suraksha_hp_lines,
    no_sanasuma_cash_lines,
    val_sanasuma_cash_accounts,
    no_suraksha_cash_units,
    val_suraksha_cash_units,
    special_discount_value,
    promotional_discount_value,
    revt_cash_price,
    revtrev_cash_price,
    rowversion,
    Customer_No,
    Customer_Name,
    co_cash_conv,
    co_remarks,
    fee_code,
    Fee_Rate,
    Tax_amount
)
select 
    --count(*)--,
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
    Customer_Order_Api.Get_Customer_No(s.order_no) Customer_No,
    customer_info_api.Get_Name(Customer_Order_Api.Get_Customer_No(s.order_no)) Customer_Name,
    (select h.cash_conv from  HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) co_cash_conv, 
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
from temp_direct_sales_tab s
where 
  s.year = '&year_i' and
  s.period = '&period' and
  substr(s.order_no,4,2) = '-R'
  --s.catalog_type != 'KOMP' AND
ORDER BY S.SHOP_CODE, S.ORDER_NO;
commit;
--***** End Cash Sales Data Transfer *****


--***** Start Hire Sales Data Transfer *****
insert into SBL_DIRECT_SALES_DETAILS_TAB(
    year,
    period,
    shop_code,
    salesman_code,
    order_no,
    hp_type,
    bb_type,
    free_item,
    state,
    sales_part,
    part_no,
    catalog_type,
    act_group,
    mc_accounts,
    cd_accounts,
    group_accounts,
    normal_accounts,
    special_accounts,
    net_hire_cash_value,
    hire_value,
    list_value,
    first_payment,
    hire_units,
    cash_units,
    cash_value,
    revert_reverse_units,
    revert_reverse_value,
    reverts_units,
    reverts_value,
    no_sanasuma_hp_units,
    val_sanasuma_hp_lines,
    no_suraksha_hp_units,
    val_suraksha_hp_lines,
    no_sanasuma_cash_lines,
    val_sanasuma_cash_accounts,
    no_suraksha_cash_units,
    val_suraksha_cash_units,
    special_discount_value,
    promotional_discount_value,
    revt_cash_price,
    revtrev_cash_price,
    rowversion,
    Customer_No,
    Customer_Name,
    co_cash_conv,
    co_remarks,
    fee_code,
    Fee_Rate,
    Tax_amount
)
select 
    --count(*)--,
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
    Customer_Order_Api.Get_Customer_No(s.order_no) Customer_No,
    customer_info_api.Get_Name(Customer_Order_Api.Get_Customer_No(s.order_no)) Customer_Name,
    (select h.cash_conv from  HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) co_cash_conv, 
    (select h.remarks from HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) co_remarks,
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
  substr(s.order_no,4,2) = '-H' and
  s.state not in ('Reverted', 'RevertReversed')
  --s.catalog_type != 'KOMP' AND
ORDER BY S.SHOP_CODE, S.ORDER_NO;
commit;
--***** End Hire Sales Data Transfer *****


--***** Start Revert Data Transfer *****
insert into SBL_DIRECT_SALES_DETAILS_TAB(
    year,
    period,
    shop_code,
    salesman_code,
    order_no,
    hp_type,
    bb_type,
    free_item,
    state,
    sales_part,
    part_no,
    catalog_type,
    act_group,
    mc_accounts,
    cd_accounts,
    group_accounts,
    normal_accounts,
    special_accounts,
    net_hire_cash_value,
    hire_value,
    list_value,
    first_payment,
    hire_units,
    cash_units,
    cash_value,
    revert_reverse_units,
    revert_reverse_value,
    reverts_units,
    reverts_value,
    no_sanasuma_hp_units,
    val_sanasuma_hp_lines,
    no_suraksha_hp_units,
    val_suraksha_hp_lines,
    no_sanasuma_cash_lines,
    val_sanasuma_cash_accounts,
    no_suraksha_cash_units,
    val_suraksha_cash_units,
    special_discount_value,
    promotional_discount_value,
    revt_cash_price,
    revtrev_cash_price,
    rowversion,
    Customer_No,
    Customer_Name,
    co_cash_conv,
    co_remarks,
    fee_code,
    Fee_Rate,
    Tax_amount
)
select 
    --count(*)--,
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
    Customer_Order_Api.Get_Customer_No(s.order_no) Customer_No,
    customer_info_api.Get_Name(Customer_Order_Api.Get_Customer_No(s.order_no)) Customer_Name,
    (select h.cash_conv from  HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) co_cash_conv, 
    (select h.remarks from HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) co_remarks,
    (select c.fee_code
      from CUSTOMER_ORDER_LINE_TAB c 
      where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1) fee_code,
    STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
      from CUSTOMER_ORDER_LINE_TAB c 
      where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1)) Fee_Rate,
    (s.reverts_value + s.special_discount_value + s.promotional_discount_value) * (STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
        from CUSTOMER_ORDER_LINE_TAB c 
        where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1))/100) Tax_amount
from temp_direct_sales_tab s
where 
  s.year = '&year_i' and
  s.period = '&period' and
  substr(s.order_no,4,2) = '-H' and
  s.state in ('Reverted')
  --s.catalog_type != 'KOMP' AND
ORDER BY S.SHOP_CODE, S.ORDER_NO;
commit;
--***** End Revert Data Transfer *****


--***** Start Revert Reversed Data Transfer *****
insert into SBL_DIRECT_SALES_DETAILS_TAB(
    year,
    period,
    shop_code,
    salesman_code,
    order_no,
    hp_type,
    bb_type,
    free_item,
    state,
    sales_part,
    part_no,
    catalog_type,
    act_group,
    mc_accounts,
    cd_accounts,
    group_accounts,
    normal_accounts,
    special_accounts,
    net_hire_cash_value,
    hire_value,
    list_value,
    first_payment,
    hire_units,
    cash_units,
    cash_value,
    revert_reverse_units,
    revert_reverse_value,
    reverts_units,
    reverts_value,
    no_sanasuma_hp_units,
    val_sanasuma_hp_lines,
    no_suraksha_hp_units,
    val_suraksha_hp_lines,
    no_sanasuma_cash_lines,
    val_sanasuma_cash_accounts,
    no_suraksha_cash_units,
    val_suraksha_cash_units,
    special_discount_value,
    promotional_discount_value,
    revt_cash_price,
    revtrev_cash_price,
    rowversion,
    Customer_No,
    Customer_Name,
    co_cash_conv,
    co_remarks,
    fee_code,
    Fee_Rate,
    Tax_amount
)
select 
    --count(*)--,
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
    Customer_Order_Api.Get_Customer_No(s.order_no) Customer_No,
    customer_info_api.Get_Name(Customer_Order_Api.Get_Customer_No(s.order_no)) Customer_Name,
    (select h.cash_conv from  HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) co_cash_conv, 
    (select h.remarks from HPNRET_CUSTOMER_ORDER_TAB h where h.order_no = s.order_no and h.contract = s.shop_code) co_remarks,
    (select c.fee_code
      from CUSTOMER_ORDER_LINE_TAB c 
      where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1) fee_code,
    STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
      from CUSTOMER_ORDER_LINE_TAB c 
      where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1)) Fee_Rate,
    (s.revert_reverse_value + s.special_discount_value + s.promotional_discount_value) * (STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
        from CUSTOMER_ORDER_LINE_TAB c 
        where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1))/100) Tax_amount
from temp_direct_sales_tab s
where 
  s.year = '&year_i' and
  s.period = '&period' and
  substr(s.order_no,4,2) = '-H' and
  s.state in ('RevertReversed')
  --s.catalog_type != 'KOMP' AND
ORDER BY S.SHOP_CODE, S.ORDER_NO;
commit;
--***** End Revert Reversed Data Transfer *****
