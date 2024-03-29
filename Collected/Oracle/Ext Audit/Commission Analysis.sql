--*****Details
select *
  from COMMISSION_VALUE_DETAIL t
 where t.site = '&SHOP_CODE'
   and t.entitlement_type = 'SCC' /*'SCS'*/ /*'ACS'*/ /*'SHPS'*/
   and t.approved_date = to_date('&APPRV_DATE', 'YYYY/MM/DD');

--***** Claim IDs
select t.claim_id
  from COMMISSION_VALUE_DETAIL t
 where t.site = '&SHOP_CODE'
   /*and t.entitlement_type = \*'SCC'*\ \*'SCS'*\ \*'ACS'*\ 'SHPS'*/
   and t.approved_date = to_date('&APPRV_DATE', 'YYYY/MM/DD')
 group by t.claim_id;

--*****Summary
select sum(t.approved_amount)
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '&CLAIM_ID'; --338283 368484
