-- Internal PO
select p.order_no,
       l.line_no,
       l.release_no,
       p.contract,
       p.vendor_no,
       trunc(p.order_date) order_date,
       l.part_no,
       l.description,
       l.buy_qty_due qty_ordered,
       /*l.buy_unit_price,
       l.date_entered,*/
       p.state,
       l.state line_state
  from IFSAPP.PURCHASE_ORDER p
 inner join IFSAPP.PURCHASE_ORDER_LINE_PART l
    on p.order_no = l.order_no
 where p.state != 'Cancelled'
      /*and l.state != 'Cancelled'*/
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(l.contract,
                                                         l.part_no) not in
       ('RBOOK', 'GIFT VOUCHER')
   and trunc(p.order_date) between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and p.contract in ('BDTB',
                      'CPKB',
                      'DASB',
                      'MNNB',
                      'DGNB',
                      'BCMB',
                      'CMCB',
                      'NAOB',
                      'PSNB',
                      'ULPB')

-- Cancelled
