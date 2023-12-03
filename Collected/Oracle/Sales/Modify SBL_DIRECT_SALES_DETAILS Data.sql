--Hire Sale Tax Information update
update SBL_DIRECT_SALES_DETAILS_TAB s
  set s.tax_amount = ((s.net_hire_cash_value + s.special_discount_value + s.promotional_discount_value) * 
      (STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code from CUSTOMER_ORDER_LINE_TAB c 
          where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1))/100))
  where --s.year = '&year_i' and
    --s.period = '&period' and
    substr(s.order_no,4,2) = '-H' and
    s.state not in ('Reverted', 'RevertReversed');
commit;


--Revert Account Tax Information update
update SBL_DIRECT_SALES_DETAILS_TAB s
  set s.tax_amount = ((s.reverts_value + s.special_discount_value + s.promotional_discount_value) * 
      (STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code from CUSTOMER_ORDER_LINE_TAB c 
          where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1))/100))
  where --s.year = '&year_i' and
    --s.period = '&period' and
    substr(s.order_no,4,2) = '-H' and
    s.state in ('Reverted');
commit;


--Revert Reversed Account Tax Information update
update SBL_DIRECT_SALES_DETAILS_TAB s
  set s.tax_amount = ((s.revert_reverse_value + s.special_discount_value + s.promotional_discount_value) * 
      (STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code from CUSTOMER_ORDER_LINE_TAB c 
          where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1))/100))
  where --s.year = '&year_i' and
    --s.period = '&period' and
    substr(s.order_no,4,2) = '-H' and
    s.state in ('RevertReversed');
commit;
