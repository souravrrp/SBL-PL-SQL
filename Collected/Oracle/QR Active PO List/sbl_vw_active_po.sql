create or replace view sbl_vw_active_po as
select l.order_no,
       l.line_no,
       l.release_no,
       l.contract,
       p.vendor_no vendor,
       trunc(p.order_date) order_date,
       l.part_no,
       l.description part_desc,
       l.buy_qty_due qty_ordered,
       nvl(rr.qty_arrived, 0) qty_received,
       (l.buy_qty_due - nvl(rr.qty_arrived, 0)) qty_remain,
       p.rowstate head_state,
       l.rowstate line_state
  from IFSAPP.purchase_order_line_tab l
 inner join IFSAPP.PURCHASE_ORDER_TAB p
    on l.order_no = p.order_no 
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
 order by 1, 2, 3;
