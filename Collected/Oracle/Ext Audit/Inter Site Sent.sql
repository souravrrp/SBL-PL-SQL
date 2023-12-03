--***** Inter Site Sent
select l.order_no,
       l.line_no,
       l.rel_no,
       l.line_item_no,
       l.contract,
       l.part_no,
       l.catalog_desc,
       l.buy_qty_due,
       l.qty_shipped,
       l.real_ship_date,
       l.customer_no,
       l.location_no,
       p.order_no,
       p.line_no,
       p.release_no,
       l.base_sale_unit_price,
       l.cost,
       l.demand_code,
       l.demand_code_db,
       p.demand_code,
       p.demand_code_db,
       l.state,
       p.state
  from IFSAPP.CUSTOMER_ORDER_LINE l
 inner join IFSAPP.PURCHASE_ORDER_LINE p
    on l.demand_order_ref1 = p.order_no
   and l.demand_order_ref2 = p.line_no
   and l.demand_order_ref3 = p.release_no
 where l.state != 'Cancelled'
   and l.real_ship_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 order by l.real_ship_date, p.order_no, p.line_no, p.release_no
