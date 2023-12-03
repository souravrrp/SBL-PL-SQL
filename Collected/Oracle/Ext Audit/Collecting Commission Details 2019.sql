-- Collecting Commission Details
select t.*
  from IFSAPP.COMMISSION_VALUE_DETAIL t
 where t.claim_id = '302941'

union all

select t.*
  from IFSAPP.COMMISSION_VALUE_DETAIL t
 where t.claim_id = '324216'

union all

select t.*
  from IFSAPP.COMMISSION_VALUE_DETAIL t
 where t.claim_id = '326493'
