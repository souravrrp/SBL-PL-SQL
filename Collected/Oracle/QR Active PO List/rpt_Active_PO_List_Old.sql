select l.order_no,
       l.line_no,
       l.release_no,
       l.contract shop_code,
       p.vendor_no warehouse,
       to_char(p.order_date, 'YYYY/MM/DD') order_date,
       l.part_no,
       l.description,
       l.buy_qty_due qty_ordered,
       nvl(rr.qty_arrived, 0) qty_received,
       (l.buy_qty_due - nvl(rr.qty_arrived, 0)) qty_remain,
       p.rowstate head_state,
       l.rowstate line_state
  from IFSAPP.purchase_order_line_tab l
 inner join IFSAPP.PURCHASE_ORDER_TAB p
    on l.order_no = p.order_no
 inner join ifsapp.shop_dts_info s
    on p.contract = s.shop_code
   and l.contract = s.shop_code
 inner join ifsapp.ware_house_info w
    on p.vendor_no = w.ware_house_name
  left join (select r.order_no,
                    r.line_no,
                    r.release_no,
                    r.part_no,
                    sum(r.qty_arrived) qty_arrived
               from ifsapp.PURCHASE_RECEIPT_NEW r
              where r.state = 'Received'
              group by r.order_no, r.line_no, r.release_no, r.part_no) rr
    on p.order_no = rr.order_no
   and l.order_no = rr.order_no
   and l.line_no = rr.line_no
   and l.release_no = rr.release_no
   and l.part_no = rr.part_no
 where p.rowstate not in ('Cancelled', 'Closed')
   and l.rowstate not in ('Cancelled', 'Closed')
   and (l.buy_qty_due - nvl(rr.qty_arrived, 0)) > 0
   and trunc(p.order_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and l.contract in
       (select a.contract
          from ifsapp.USER_ALLOWED_SITE_TAB a
         where a.userid = ifsapp.fnd_session_api.Get_Fnd_User)
 order by 4, 5, 1, 2, 3
