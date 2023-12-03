
select * from SBL_PI_SHOP_STOCK_IN_FRANCHISE t;

select t.f_id F_ID, t.catalog_no CATALOG_NO, t.qty QTY
  from SBL_PI_SHOP_STOCK_IN_FRANCHISE t, SBL_PI_FRANCHISE_INFO i
 where i.city = '&city'
   and i.contact_person_name = '&cperson'
   and t.f_id = i.f_id
   and t.site = '&SHOP_CODE'
   and t.catalog_no = '&PART_NO'
   and t.checked = 'N';

select f.site,
       f.catalog_no,
       f.qty,
       f.problem,
       f.frn_name,
       f.checked,
       f.checked_time
  from ifsapp.SBL_PI_SHOP_STOCK_IN_FRANCHISE f
 where /*f.checked = 'Y'
   and*/ f.site = '&SHOP_CODE'
   and f.catalog_no = '&PRODUCT_CODE';

/*
update ifsapp.SBL_PI_SHOP_STOCK_IN_FRANCHISE f
   set f.checked = 'N', f.checked_time = ''
 where f.site = '&SHOP_CODE'
   and f.catalog_no like '&PRODUCT_CODE';
commit;
*/

select sum(qty_s) con
  from (select nvl(count(w.wo_no), 0) qty_s
          from ifsapp.SBL_WO_INFO_INVENTORY w
         where w.product_code = '&PRODUCT_CODE'
           and w.product_site = '&SHOP_CODE'
        union all
        select nvl(sum(t.qty), 0) qty_s
          from ifsapp.SBL_PI_SHOP_STOCK_IN_FRANCHISE t
         where t.site = '&SHOP_CODE'
           and t.catalog_no = '&PRODUCT_CODE'
           and t.checked = 'Y');
