select m.spare_contract,
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
 order by m.spare_contract,
          m.wo_no,
          m.maint_material_order_no,
          m.line_item_no

/*select h.*
from IFSAPP.HISTORICAL_SEPARATE h
where trunc(h.reg_date) between to_date('2014/1/1', 'YYYY/MM/DD') AND to_date('2014/8/26', 'YYYY/MM/DD')

IFSAPP.ACTIVE_SEPARATE_API
*/
