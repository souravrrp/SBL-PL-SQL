select 
    --s.*
    --distinct s.state
    s.year,
    s.period,
    --s.shop_code,
    'cash_value' item,
    sum(s.cash_value) amount
from temp_direct_sales_tab s
where 
  s.year = '&year_i' and
  --s.period = '&period' and
  s.period between '&start_period' and '&end_period' and
  s.catalog_type != 'KOMP' AND
  substr(s.order_no,4,2) = '-R' and
  --s.state not in ('Returned') and
  s.shop_code in ('DITF'/*, 'BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C'*/)
  /*s.shop_code not in ('DITF', 'BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 
    'JWSS', 'SAOS', 'SAPM', 'SCSM', 'SESM', 'SWSS', 'WSMO')*/ --and
  --s.order_no in (select h.order_no from  HPNRET_CUSTOMER_ORDER_TAB h where h.cash_conv = 'FALSE')
group by s.year, s.period, 'cash_value'--, s.shop_code


--************************
select 
    --s.*
    --distinct s.state
    s.year,
    s.period,
    --s.shop_code,
    'hire_value' item,
    nvl(sum(s.net_hire_cash_value), 0) amount
from temp_direct_sales_tab s
where 
  s.year = '&year_i' and
  --s.period = '&period' and
  s.period between '&start_period' and '&end_period' and
  s.catalog_type != 'KOMP' AND
  substr(s.order_no,4,2) = '-H' and
  --s.order_no = 'DBA-H3048' and
  --s.state not in('CashConverted') and --RevertReversed, Reverted, Returned, Invoiced, ExchangedIn, CashConverted, SALE
  s.shop_code in ('DITF'/*, 'BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C'*/)
  /*s.shop_code not in ('DITF', 'BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 
    'JWSS', 'SAOS', 'SAPM', 'SCSM', 'SESM', 'SWSS', 'WSMO')*/
group by s.year, s.period, 'hire_value'--, s.shop_code


--**********************
select 
    --s.*
    --distinct s.state
    s.year,
    s.period,
    --s.shop_code,
    'hire_value' item,
    nvl(sum(abs(s.net_hire_cash_value)), 0) amount
from temp_direct_sales_tab s
where 
  s.year = '&year_i' and
  --s.period = '&period' and
  s.period between '&start_period' and '&end_period' and
  s.catalog_type != 'KOMP' AND
  substr(s.order_no,4,2) = '-H' and
  --s.order_no = 'DBA-H3048' and
  s.state in('CashConverted') and --RevertReversed, Reverted, Returned, Invoiced, ExchangedIn, CashConverted, SALE
  s.shop_code not in ('DITF', 'BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 
    'JWSS', 'SAOS', 'SAPM', 'SCSM', 'SESM', 'SWSS', 'WSMO')
group by s.year, s.period, 'hire_value'--, s.shop_code


--**********************
select 
    --s.*
    --distinct s.state
    s.year,
    s.period,
    s.shop_code,
    --'hire_value' item,
    sum(s.cash_value) cash_amount,
    sum(s.net_hire_cash_value) hire_amount,
    sum(s.reverts_value) reverts_value,
    sum(s.revert_reverse_value) revert_reverse_value,
    sum(s.cash_value) + sum(s.net_hire_cash_value) + sum(s.reverts_value) - sum(s.revert_reverse_value) sales_value
from temp_direct_sales_tab s
where 
  s.year = '&year_i' and
  --s.period = '&period' and
  s.period between '&start_period' and '&end_period' and
  s.catalog_type != 'KOMP' AND
  --substr(s.order_no,4,2) = '-H' and
  --s.order_no = 'DBA-H3048' and
  s.shop_code not in ('BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 
    'JWSS', 'SAOS', 'SAPM', 'SCSM', 'SESM', 'SWSS', 'WSMO')
group by s.year, s.period, s.shop_code