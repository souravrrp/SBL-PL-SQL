--***** Site-wise IT Asset Status Summary
select tt.receiver_site_code current_location,
       s.site_area,
       s.site_district,
       tt.receiver_emp_id    current_user_id,
       EE.EMP_NAME           Current_USER_NAME,
       tt.part_no,
       mt.family_desc,
       /*OT.SUPPLIER_ID*/
       sum(tt.qty) qtn
  from SBL_INV_TRANSACTIONS_TAB tt,
       /*SBL_ITEM_SERIAL_TAB      st,*/
       SBL_EMPLOYEE_INVENTORY EE,
       /*SBL_PURCHASE_ORDER_TAB   OT,*/
       /*SBL_IT_INV_SITE_INFO_TAB it,*/
       SBL_INVENTORY_ITEM_TAB   mn,
       SBL_ITEM_FAMILY_TAB      mt,
       SBL_IT_INV_SITE_INFO_TAB s
 where /*tt.oem = st.oem_no
   and tt.serial_no = st.serial_no*/
/*and*/
 tt.receiver_emp_id = EE.EMP_ID
/*and ot.po_no = st.po_no
and it.site_code = tt.receiver_site_code
and st.status = 'IN_USE'*/
 and tt.transaction_type in ('ASSIGN_TO_EMP', 'ASSIGN_TO_SHOP')
 and tt.part_no = mn.part_no
 and mn.family_id = mt.family_id
 and tt.receiver_site_code = s.site_code
/*and upper(it.site_area) like upper('&Area')
and upper(it.site_district) like upper('&District')*/
 and tt.receiver_site_code = /*'MYMB'*/ 'DASB'
 group by tt.receiver_site_code,
          s.site_area,
          s.site_district,
          tt.receiver_emp_id,
          EE.EMP_NAME,
          tt.part_no,
          mt.family_desc
