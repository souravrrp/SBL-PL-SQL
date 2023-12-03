--***** Shopwise IT Asset Status Details
select s.site_area,
       s.site_district,
       s.site_type,
       i.receiver_site_code shop_code,
       i.receiver_emp_id emp_id,
       (select e.emp_name
          from IFSAPP.SBL_EMPLOYEE_INVENTORY e
         where e.emp_id = i.receiver_emp_id) emp_name,
       i.part_no,
       p.product_description,
       (select f.family_desc
          from IFSAPP.SBL_ITEM_FAMILY_TAB f
         where f.family_id = p.family_id) family_desc,
       (select c.category_desc
          from IFSAPP.SBL_CATEGORY_TAB c
         where c.category_id = p.category_id) category_desc,
       i.oem,
       i.serial_no,
       p.asset_class,
       i.approval_status
  from (select t.part_no, --***** Currently available IT Asset at Shop or EMP
               t.oem,
               t.serial_no,
               t.receiver_emp_id,
               t.receiver_site_code,
               t.approval_status
          from IFSAPP.SBL_INV_TRANSACTIONS_TAB t
         where t.transaction_type in ('ASSIGN_TO_EMP', 'ASSIGN_TO_SHOP')
        
        minus
        
        select t.part_no,
               t.oem,
               t.serial_no,
               t.receiver_emp_id,
               t.receiver_site_code,
               t.approval_status
          from IFSAPP.SBL_INV_TRANSACTIONS_TAB t
         where t.transaction_type in ('BACK_FROM_EMP', 'BACK_FROM_SHOP')) i
 inner join IFSAPP.SBL_IT_INV_SITE_INFO_TAB s
    on i.receiver_site_code = s.site_code
 inner join IFSAPP.SBL_INVENTORY_ITEM_TAB p
    on i.part_no = p.part_no
 where s.site_type in ('SP_SHOP', 'SP_ESA', 'SP_DSA')
   and s.site_area like '&area_code'
   and s.site_district like '&district_code'
   and i.receiver_site_code like '&shop_code'
 order by to_number(s.site_district),
          i.receiver_site_code,
          i.receiver_emp_id
