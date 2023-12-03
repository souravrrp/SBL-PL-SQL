-- Customer Order against Internal PO
select l.order_no,
       l.line_no,
       l.rel_no,
       l.line_item_no,
       l.contract,
       l.customer_no,
       l.real_ship_date,
       l.part_no,
       l.catalog_desc      "DESCRIPTION",
       l.demand_order_ref1 po_no,
       l.demand_order_ref2 po_line_no,
       l.demand_order_ref3 po_rel_no,
       l.buy_qty_due       qty_ordered,
       l.qty_shipped,
       c.state,
       l.state             line_state
  from ifsapp.CUSTOMER_ORDER_LINE l
 inner join ifsapp.CUSTOMER_ORDER c
    on l.order_no = c.order_no
 where c.state != 'Cancelled'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(l.contract,
                                                         l.part_no) not in
       ('RBOOK', 'GIFT VOUCHER')
   and trunc(c.date_entered) between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and c.customer_no in ('BDTB',
                         'CPKB',
                         'DASB',
                         'MNNB',
                         'DGNB',
                         'BCMB',
                         'CMCB',
                         'NAOB',
                         'PSNB',
                         'ULPB')
/*and l.order_no = 'RWH-R29293';*/
