select p.order_no,
       p.line_no,
       p.release_no,
       p.contract shop_code,
       p.vendor warehouse,
       to_char(p.order_date, 'YYYY/MM/DD') order_date,
       p.part_no,
       p.part_desc,
       p.qty_ordered,
       p.qty_received,
       p.qty_remain,
       p.head_state,
       p.line_state
  from IFSAPP.SBL_VW_ACTIVE_PO p
 inner join ifsapp.shop_dts_info s
    on p.contract = s.shop_code
 inner join ifsapp.ware_house_info w
    on p.vendor = w.ware_house_name
 where p.qty_remain > 0
   and p.order_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and p.contract in
       (select a.contract
          from ifsapp.USER_ALLOWED_SITE_TAB a
         where a.userid = ifsapp.fnd_session_api.Get_Fnd_User)
 order by 4, 5, 1, 2, 3
