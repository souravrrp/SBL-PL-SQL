--***** Inter Site Sent Summary
select l.contract,
       l.part_no,
       l.contract || '-' || l.part_no contract_part_no,
       l.catalog_desc,
       sum(l.buy_qty_due) qty_ordered,
       sum(l.qty_shipped) qty_shipped,
       sum(round(l.qty_shipped *
                 (select c.cost
                    from ifsapp.INVENT_ONLINE_COST_TAB c
                   where c.year = extract(year from l.real_ship_date)
                     and c.period = extract(month from l.real_ship_date)
                     and c.contract = l.contract
                     and c.part_no = l.part_no),
                 2)) total_cost
  from IFSAPP.CUSTOMER_ORDER_LINE l
 inner join IFSAPP.PURCHASE_ORDER_LINE p
    on l.demand_order_ref1 = p.order_no
   and l.demand_order_ref2 = p.line_no
   and l.demand_order_ref3 = p.release_no
 where l.state != 'Cancelled'
   and l.real_ship_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 group by l.contract, l.part_no, l.catalog_desc
 order by 1, 2
