select *
  from COMMISSION_VALUE_DETAIL t
 where /*t.site = 'TGTD'
   and t.entitlement_type = 'ACS'
   and t.approved_date = to_date('2016/6/19', 'YYYY/MM/DD')*/ 
   t.claim_id = 322922

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where /*t.site = 'DPLB'
   and t.entitlement_type = 'SHPS'
   and t.approved_date = to_date('2018/8/26', 'YYYY/MM/DD')*/ 
   t.claim_id = 333088

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where /*t.site = 'BCFB'
   and t.entitlement_type = 'SHPS'
   and t.approved_date = to_date('2018/12/9', 'YYYY/MM/DD')*/ 
   t.claim_id = 350637

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where /*t.site = 'SNGB'
   and t.entitlement_type = 'SCS'
   and t.approved_date = to_date('2017/4/8', 'YYYY/MM/DD')*/ 
   t.claim_id = 310077
 order by 5
