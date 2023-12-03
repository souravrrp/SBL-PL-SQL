--*****************Sales Data
select 
    s.year,
    s.period,
    s.shop_code,
    'sales_value' item,
    sum(s.cash_value) + sum(s.net_hire_cash_value) amount
from SBL_DIRECT_SALES_DETAILS_TAB s
where 
  s.year = '&year_i' and
  --s.period = '&period' and
  s.period between '&start_period' and '&end_period' and
  s.catalog_type != 'KOMP' AND
  s.shop_code not in ('BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 
    'JWSS', 'SAOS', 'SAPM', 'SCSM', 'SESM', 'SWSS', 'WSMO')
group by s.year, s.period, s.shop_code
  
union

--*****************Shopwise BE Expenses Summary
select
    v_be.year,
    v_be.period,
    v_be.contract,
    v_be.rsl_item item,
    sum(v_be.amount) amount
from
  --***************BE Expenses List
  (select
      extract(year from r.from_date) year,
      extract(month from r.from_date) period,
      r.contract,
      i.rsl_item_description rsl_item,
      i.amount
  from 
    HPNRET_RSL_ITEM i,
    HPNRET_RSL r
  where 
    r.company = i.company and
    r.contract = i.contract and
    r.sequence_no = i.sequence_no and
    substr(r.sequence_no, 4, 3) = 'RSL' and
    i.rsl_item_type_db = 'EXPENSE' and
    i.rsl_item_id like 'BE%' and
    i.amount > 0 and
    r.from_date >= to_date('&year_i'||'/'||'&start_period'||'/1', 'YYYY/MM/DD') and
    r.to_date <= last_day(to_date('&year_i'||'/'||'&end_period'||'/1', 'YYYY/MM/DD'))) v_be
group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

union

--*****************Shopwise BA Expenses Summary
select
    v_be.year,
    v_be.period,
    v_be.contract,
    v_be.rsl_item item,
    sum(v_be.amount) amount
from
  --***************BA Expenses List
  (select
      extract(year from r.from_date) year,
      extract(month from r.from_date) period,
      r.contract,
      i.rsl_item_description rsl_item,
      i.amount
  from 
    HPNRET_RSL_ITEM i,
    HPNRET_RSL r
  where 
    r.company = i.company and
    r.contract = i.contract and
    r.sequence_no = i.sequence_no and
    substr(r.sequence_no, 4, 3) = 'RSL' and
    i.rsl_item_type_db = 'EXPENSE' and
    i.rsl_item_id like 'BA%' and
    i.amount > 0 and
    r.from_date >= to_date('&year_i'||'/'||'&start_period'||'/1', 'YYYY/MM/DD') and
    r.to_date <= last_day(to_date('&year_i'||'/'||'&end_period'||'/1', 'YYYY/MM/DD'))) v_be
group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

union

--*****************Shopwise BI Expenses Summary
select
    v_be.year,
    v_be.period,
    v_be.contract,
    v_be.rsl_item item,
    sum(v_be.amount) amount
from
  --**************BI Expenses List
  (select
      extract(year from r.from_date) year,
      extract(month from r.from_date) period,
      r.contract,
      i.rsl_item_description rsl_item,
      i.amount
  from 
    HPNRET_RSL_ITEM i,
    HPNRET_RSL r
  where 
    r.company = i.company and
    r.contract = i.contract and
    r.sequence_no = i.sequence_no and
    substr(r.sequence_no, 4, 3) = 'RSL' and
    i.rsl_item_type_db = 'RECEIPT' and
    i.rsl_item_id like 'BI%' and
    i.amount > 0 and
    r.from_date >= to_date('&year_i'||'/'||'&start_period'||'/1', 'YYYY/MM/DD') and
    r.to_date <= last_day(to_date('&year_i'||'/'||'&end_period'||'/1', 'YYYY/MM/DD'))) v_be
group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

union

--*****************Shopwise BL Expenses Summary
select
    v_be.year,
    v_be.period,
    v_be.contract,
    v_be.rsl_item item,
    sum(v_be.amount) amount
from
  --***************BL Expenses List
  (select
      extract(year from r.from_date) year,
      extract(month from r.from_date) period,
      r.contract,
      i.rsl_item_description rsl_item,
      i.amount
  from 
    HPNRET_RSL_ITEM i,
    HPNRET_RSL r
  where 
    r.company = i.company and
    r.contract = i.contract and
    r.sequence_no = i.sequence_no and
    substr(r.sequence_no, 4, 3) = 'RSL' and
    i.rsl_item_type_db = 'RECEIPT' and
    i.rsl_item_id like 'BL%' and
    i.amount > 0 and
    r.from_date >= to_date('&year_i'||'/'||'&start_period'||'/1', 'YYYY/MM/DD') and
    r.to_date <= last_day(to_date('&year_i'||'/'||'&end_period'||'/1', 'YYYY/MM/DD'))) v_be
group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

union

--*****************Shopwise Service Charge Summary
select
    v_be.year,
    v_be.period,
    v_be.contract,
    v_be.rsl_item item,
    sum(v_be.amount) amount
from
  --***************Service Charge List
  (select
      extract(year from r.from_date) year,
      extract(month from r.from_date) period,
      r.contract,
      i.rsl_item_description rsl_item,
      i.amount
  from 
    HPNRET_RSL_ITEM i,
    HPNRET_RSL r
  where 
    r.company = i.company and
    r.contract = i.contract and
    r.sequence_no = i.sequence_no and
    substr(r.sequence_no, 4, 3) = 'RSL' and
    i.rsl_item_description = 'Service Charge' and
    i.amount > 0 and
    r.from_date >= to_date('&year_i'||'/'||'&start_period'||'/1', 'YYYY/MM/DD') and
    r.to_date <= last_day(to_date('&year_i'||'/'||'&end_period'||'/1', 'YYYY/MM/DD'))) v_be
group by v_be.year, v_be.period, v_be.contract, v_be.rsl_item

--order by year, period, contract, item,
