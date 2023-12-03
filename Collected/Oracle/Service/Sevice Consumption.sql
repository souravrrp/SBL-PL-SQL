--Consumption on Active WO
select m.spare_contract contract,
       m.wo_no,
       m.maint_material_order_no,
       m.line_item_no,
       m.part_no,
       to_char(m.date_required, 'YYYY/MM/DD') date_required,
       to_char(a.reg_date, 'YYYY/MM/DD') reg_date,
       a.work_type_id,
       IFSAPP.WORK_TYPE_API.Get_Description(a.work_type_id) work_type_desc,
       m.plan_qty,
       m.qty_returned,
       m.qty,
       a.state
  from ifsapp.MAINT_MATERIAL_REQ_LINE m
  left join ifsapp.ACTIVE_SEPARATE a
    on m.wo_no = a.wo_no
 where trunc(a.reg_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and a.work_type_id != 'PJ-REF'
   and m.part_no like /*'BO-COMP-CNE60520M-260W'*/ /*'BO-COMP-GNEV222S-220W'*/ 'SR-RELAY-SDC-300SGHL'
/*order by m.spare_contract,
m.wo_no,
m.maint_material_order_no,
m.line_item_no*/

union

--Consumption on Historical WO
select m.spare_contract contract,
       m.wo_no,
       m.maint_material_order_no,
       m.line_item_no,
       m.part_no,
       to_char(m.date_required, 'YYYY/MM/DD') date_required,
       to_char(h.reg_date, 'YYYY/MM/DD') reg_date,
       h.work_type_id,
       IFSAPP.WORK_TYPE_API.Get_Description(h.work_type_id) work_type_desc,
       m.plan_qty,
       m.qty_returned,
       m.qty,
       h.wo_status_id status
  from ifsapp.MAINT_MATERIAL_REQ_LINE m
  left join ifsapp.HISTORICAL_SEPARATE h
    on m.wo_no = h.wo_no
 where trunc(h.reg_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and h.work_type_id /*!*/= 'PJ-REF'
   and m.part_no like /*'BO-COMP-CNE60520M-260W'*/ /*'BO-COMP-GNEV222S-220W'*/ 'SR-RELAY-SDC-300SGHL'
/*order by m.spare_contract,
m.wo_no,
m.maint_material_order_no,
m.line_item_no*/

 order by 1, 2, 3, 4
