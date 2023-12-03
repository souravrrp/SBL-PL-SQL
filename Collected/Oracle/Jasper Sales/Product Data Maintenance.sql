--Monitors, Keyboards, & Mouses to be changed to CPACS (COMPUTER-ACCESSORIES)
select t.product_code,
       t.product_desc,
       t.product_family_code,
       t.product_family
  from SBL_JR_PRODUCT_DTL_INFO t
 where t.product_code like '%COM-%'
   and (t.product_code like '%LCD%' or t.product_code like '%LED%' or
       t.product_code like '%CRT%' or t.product_code like '%FLAT%' or
       t.product_code like '%KEYBOARD%' or t.product_code like '%MOUSE%' or
       t.product_family = 'MONITOR')
 /*order by t.product_code*/

union all

--Apple Items to be changed to CPACS (COMPUTER-ACCESSORIES)
select t.product_code,
       t.product_desc,
       t.product_family_code,
       t.product_family
  from SBL_JR_PRODUCT_DTL_INFO t
 where (t.product_code like 'AEACS-%' or t.product_code like 'AEPOD-%')
 /*order by t.product_code*/

union all

--Batteries PF to be corrected
select t.product_code,
       t.product_desc,
       t.product_family_code,
       t.product_family
  from SBL_JR_PRODUCT_DTL_INFO t
 where t.product_code like '%BAT-%'
 order by 4,1;

--Washing Machine PF to be corrected
select t.product_code,
       t.product_desc,
       t.product_family_code,
       t.product_family
  from SBL_JR_PRODUCT_DTL_INFO t
 where t.product_family_code = 'WMFAT'
 order by t.product_code;

--Furniture PF to be corrected
select t.product_code,
       t.product_desc,
       t.product_family_code,
       t.product_family
  from SBL_JR_PRODUCT_DTL_INFO t
 where t.product_code like '%FUR-%'
 order by t.Product_Family;
