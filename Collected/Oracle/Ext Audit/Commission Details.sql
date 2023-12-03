-- Collection Commissions
select *
  from IFSAPP.COMMISSION_VALUE_DETAIL t
 where t.claim_id = '358107' -- DKBB, 2019/1/27

union all

select *
  from IFSAPP.COMMISSION_VALUE_DETAIL t
 where t.claim_id = '358308' -- JESB, 2019/1/27

union all

select *
  from IFSAPP.COMMISSION_VALUE_DETAIL t
 where t.claim_id = '361167' -- DRRB, 2019/2/17


-- Selling Commission
select *
  from IFSAPP.COMMISSION_VALUE_DETAIL t
 where t.claim_id = '355037' -- RGPB, 2019/1/6

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '356181' -- KRLB, 2019/1/13

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '356886' -- FBRB, 2019/1/20

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '356936' -- SNGB, 2019/1/20

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '357809' -- MDNB, 2019/1/27

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '358609' -- CPTB, 2019/1/27

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '359814' -- LFNM, 2019/1/31

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '360245' -- GPBB, 2019/2/10

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '361129' -- SNAB, 2019/2/17

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '361372' -- MKKB, 2019/2/17

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '361804' -- BGTB, 2019/2/17

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '362720' -- JMPB, 2019/2/24

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '369029' -- DJBB, 2019/3/31

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '363304' -- SFID, 2019/2/24

union all

select *
  from COMMISSION_VALUE_DETAIL t
 where t.claim_id = '368484' -- JMPB, 2019/3/31

 order by 5
