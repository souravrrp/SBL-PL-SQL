--*****
select c.group_no, p.product_group, j.product_family, c.product_code
  from ifsapp.PRODUCT_CATEGORY_INFO   c,
       ifsapp.SBL_PRODUCT_INFO        p,
       ifsapp.SBL_JR_PRODUCT_DTL_INFO j
 where c.group_no = p.group_no
   and c.product_code = j.product_code
   and j.product_family = 'OVEN-GAS' /*'COMPUTER-ACCESSORIES'*/
 order by c.group_no, c.product_code;

--*****
select * from SBL_PI_DEFECT_LIST l;

--*****
select l.defect_id, l.defect_type
  from ifsapp.SBL_PI_DEFECT_LIST l
 inner join ifsapp.SBL_PRODUCT_INFO p
    on l.product_group = p.product_group
 inner join ifsapp.PRODUCT_CATEGORY_INFO c
    on p.group_no = c.group_no
 where c.product_code = 'SRGO-GCB8401';

--*****
select * from ifsapp.SBL_PI_DEFECT_INFO d where d.shop_code = 'BDCB';

--*****
select d.sl_no, l.defect_type
  from ifsapp.SBL_PI_DEFECT_INFO d
 inner join ifsapp.SBL_PI_DEFECT_LIST l
    on d.defect_id = l.defect_id
 where d.count_year = 2019
   and d.count_period = 12
   and d.shop_code = $SHOP_CODE
   and d.product_code = $PRODUCT_CODE;

--*****
select nvl(max(d.sl_no), 0) max_no
  from ifsapp.SBL_PI_DEFECT_INFO d
 where d.count_year = 2019
   and d.count_period = 12
   and d.shop_code = $SHOP_CODE
   and d.product_code = $PRODUCT_CODE;

--*****
insert into ifsapp.SBL_PI_DEFECT_INFO
  (COUNT_YEAR, COUNT_PERIOD, SHOP_CODE, PRODUCT_CODE, SL_NO, DEFECT_ID)
values
  (2019, 12, $SHOP_CODE, $PRODUCT_CODE, $n, $defect_id);

--*****
delete from ifsapp.SBL_PI_DEFECT_INFO d
 where d.shop_code = $SHOP_CODE
   and d.product_code = $PRODUCT_CODE
   and d.sl_no = $n;

--*****
select count(d.product_code) total_md
  from ifsapp.SBL_PI_DEFECT_INFO d
 where d.shop_code = '$SHOP_CODE'
   and d.product_code = '$PRODUCT_CODE';

--*****
update ifsapp.SBL_INVENTORY_COUNTING_DTS c
   set c.qty_defective = '$qty_defective'
 where c.site = '$SHOP_CODE'
   and c.catalog_no = '$PRODUCT_CODE';

--***** Blank Defects
select c.site,
       c.catalog_no,
       c.qty_onhand,
       c.qty_in_transit,
       c.qty_defective,
       b.qtn
  from ifsapp.SBL_INVENTORY_COUNTING_DTS c
 inner join (select t.shop_code, t.product_code, count(t.sl_no) qtn
               from ifsapp.SBL_PI_DEFECT_INFO t
              where t.defect_id is null
              group by t.shop_code, t.product_code) b
    on c.site = b.shop_code
   and c.catalog_no = b.product_code
 order by 1, 2

--***** Major Defect Summary
select d.product_code,
       (select p.product_family
          from SBL_JR_PRODUCT_DTL_INFO p
         where p.product_code = d.product_code) product_family,
       l.defect_type,
       count(d.sl_no) quantity
  from ifsapp.SBL_PI_DEFECT_INFO d
 inner join ifsapp.SBL_PI_DEFECT_LIST l
    on d.defect_id = l.defect_id
 where d.count_year = 2019
   and d.count_period = 12
/*and d.shop_code = '&SHOP_CODE'
and d.product_code = '&PRODUCT_CODE'*/
 group by d.product_code, l.defect_type
 order by 2, 1, 3;

