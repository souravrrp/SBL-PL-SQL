select 
    --count(*)
    s.year,
    s.period,
    s.shop_code,
    s.salesman_code,
    s.order_no,
    --s.hp_type,
    --s.bb_type,
    s.free_item,
    s.state,
    s.sales_part,
    --s.part_no,
    --s.catalog_type,
    --s.act_group,
    --s.mc_accounts,
    --s.cd_accounts,
    --s.group_accounts,
    --s.normal_accounts,
    --s.special_accounts,
    --s.net_hire_cash_value,
    --s.hire_value,
    --s.list_value,
    --s.first_payment,
    (select 
        max(c.base_sale_unit_price) base_sale_unit_price
      from customer_order_line_tab c        
      where c.order_no = s.order_no and c.catalog_no = s.sales_part
      group by c.order_no, c.catalog_no) base_sale_unit_price,
    --s.hire_units,
    s.cash_units,
    s.cash_value,
    --s.revert_reverse_units,
    --s.revert_reverse_value,
    --s.reverts_units,
    --s.reverts_value,
    --s.no_sanasuma_hp_units,
    --s.val_sanasuma_hp_lines,
    --s.no_suraksha_hp_units,
    --s.val_suraksha_hp_lines,
    --s.no_sanasuma_cash_lines,
    --s.val_sanasuma_cash_accounts,
    --s.no_suraksha_cash_units,
    --s.val_suraksha_cash_units,
    s.special_discount_value,
    s.promotional_discount_value,
    --s.revt_cash_price,
    --s.revtrev_cash_price,
    --s.rowversion,
    s.customer_no,
    s.customer_name,
    CUSTOMER_INFO_COMM_METHOD_API.Get_Value(s.customer_no, 1) tel_no,
    --s.co_cash_conv,
    s.co_remarks,
    s.fee_code,
    s.fee_rate,
    s.tax_amount--,
    /*(select 
        --*
        a.amount
    from COMMISSION_AGREE_LINE a
    where
      a.agreement_id = 'SP_SC_RTL' and
      a.commission_sales_type_db = 'CASH' and
      a.catalog_no = s.sales_part and
      ((a.valid_from <= to_date('2014/1/1', 'YYYY/MM/DD') and a.valid_to >= to_date('2014/2/28', 'YYYY/MM/DD'))
      or
      (a.valid_from >= to_date('2014/1/1', 'YYYY/MM/DD') and a.valid_to <= to_date('2014/2/28', 'YYYY/MM/DD')))) commission_amout*/
from sbl_direct_sales_details_tab s
where 
  s.year = '&year_i' and
  s.period <= '&period' and
  s.shop_code = 'DITF' and
  s.catalog_type != 'KOMP' and
  --s.sales_part = 'SYPHS-W150' and
  substr(s.order_no,4,2) = '-R' --and
  --s.order_no = 'SCS-R873'
ORDER BY S.YEAR, S.PERIOD, S.SHOP_CODE, S.ORDER_NO
