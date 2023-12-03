select 
    --sum(s.revert_reverse_value),
    --sum(s.reverts_value)
    --sum(s.cash_value)
    --sum(s.net_hire_cash_value)
    --count(distinct s.order_no)
    s.*,
    --(select sum(h.cash_price) from HPNRET_HP_DTL_TAB h where h.account_no = s.order_no) nsp2,
    (select 
      h2.normal_cash_price
    from hpnret_form249_arrears_tab h2
    where
      h2.acct_no = s.order_no and
      h2.year = extract(year from (to_date(s.year||'/'||s.period||'/1', 'YYYY/MM/DD') - 1)) and
      h2.period = extract(month from (to_date(s.year||'/'||s.period||'/1', 'YYYY/MM/DD') - 1))) nsp,
    --(select sum(h.cash_price) - ((sum(h.discount) / 100) * sum(h.cash_price)) + sum(h.service_charge) from HPNRET_HP_DTL_TAB h where h.account_no = s.order_no) list_price2,
    (select 
      h2.list_price
    from hpnret_form249_arrears_tab h2
    where
      h2.acct_no = s.order_no and
      h2.year = extract(year from (to_date(s.year||'/'||s.period||'/1', 'YYYY/MM/DD') - 1)) and
      h2.period = extract(month from (to_date(s.year||'/'||s.period||'/1', 'YYYY/MM/DD') - 1))) list_price,
    (select 
      h2.hire_cash_price
    from hpnret_form249_arrears_tab h2
    where
      h2.original_acct_no = s.order_no and
      h2.year = extract(year from (to_date(s.year||'/'||s.period||'/1', 'YYYY/MM/DD') - 1)) and
      h2.period = extract(month from (to_date(s.year||'/'||s.period||'/1', 'YYYY/MM/DD') - 1))) hire_cash_price,
    (select 
      h2.total_ucc
    from hpnret_form249_arrears_tab h2
    where
      h2.original_acct_no = s.order_no and
      h2.year = extract(year from (to_date(s.year||'/'||s.period||'/1', 'YYYY/MM/DD') - 1)) and
      h2.period = extract(month from (to_date(s.year||'/'||s.period||'/1', 'YYYY/MM/DD') - 1))) total_ucc,
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
    round(((select sum(h.cash_price) from HPNRET_HP_DTL_TAB h where h.account_no = s.order_no) 
      + (select sum(h.discount) from HPNRET_HP_DTL_TAB h where h.account_no = s.order_no)) 
      * (STATUTORY_FEE_API.Get_Fee_Rate('SBL', (select c.fee_code
        from CUSTOMER_ORDER_LINE_TAB c 
        where c.order_no = s.order_no and c.catalog_no = s.sales_part and rownum <=1))/100),2) Tax_amount
    /*(select 
      h2.vat
      from hpnret_form249_arrears_tab h2
      where
      h2.acct_no = s.order_no and
      h2.year = (select 
      max(h2.year) year
      from hpnret_form249_arrears_tab h2)
      and
      h2.period = (select 
      max(h2.period) period
      from hpnret_form249_arrears_tab h2
      where 
      h2.year = (select 
      max(h2.year) year
      from hpnret_form249_arrears_tab h2))) Tax_amount2*/
from temp_direct_sales_tab /*SBL_DIRECT_SALES_DETAILS_TAB*/ s
where 
  s.year = '&year_i' and
  s.period = '&period' and
  s.catalog_type != 'KOMP' AND
  s.state in ('RevertReversed', 'Reverted') --and ('CashConverted', 'RevertReversed', 'Reverted')
  --substr(s.order_no,4,2) = '-R' --and
  --s.order_no = 'JSB-R139'
  /*s.order_no in (select h.order_no from  HPNRET_CUSTOMER_ORDER_TAB h 
      where \*h.contract = s.shop_code and*\ 
        --h.cash_conv = 'TRUE'and 
        h.remarks like 'Cash Converted%')*/
ORDER BY S.SHOP_CODE, S.ORDER_NO

--select distinct s.state from temp_direct_sales_tab s
