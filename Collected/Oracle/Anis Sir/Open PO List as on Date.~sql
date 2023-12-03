--Partial Delivery Open PO
select p.order_no,
       l.line_no,
       l.release_no,
       (select c.order_no
          from IFSAPP.CUSTOMER_ORDER_TAB c
         where c.customer_po_no = p.order_no) REF_CO_NO,
       p.vendor_no,
       l.contract,
       (select s.area_code
          from IFSAPP.SHOP_DTS_INFO s
         where s.shop_code = l.contract) area_code,
       (select s.district_code
          from IFSAPP.SHOP_DTS_INFO s
         where s.shop_code = l.contract) district_code,
       l.part_no,
       l.description,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             l.part_no)) product_family,
       l.buy_qty_due qty_ordered,
       (l.buy_qty_due - pr.qty_arrived) qty_remain,
       trunc(p.order_date) order_date,
       l.wanted_delivery_date,
       l.planned_receipt_date,
       l.rowstate line_status,
       p.rowstate head_status,
       (select cl.rowstate
          from IFSAPP.CUSTOMER_ORDER_LINE_TAB cl
         where cl.demand_order_ref1 = l.order_no
           and cl.demand_order_ref2 = l.line_no
           and cl.demand_order_ref3 = l.release_no) co_status
  from IFSAPP.PURCHASE_ORDER_LINE_TAB l
 inner join (select r.order_no,
                    r.line_no,
                    r.release_no,
                    sum(r.qty_arrived) qty_arrived
               from IFSAPP.PURCHASE_RECEIPT_TAB r
              where r.rowstate = 'Received'
              group by r.order_no, r.line_no, r.release_no) pr
    on l.order_no = pr.order_no
   and l.line_no = pr.line_no
   and l.release_no = pr.release_no
 inner join IFSAPP.PURCHASE_ORDER_TAB p
    on l.order_no = p.order_no
   and pr.order_no = p.order_no
 where p.rowstate = 'Received'
   and p.vendor_no in ('APWH',
                       'BBWH',
                       'BWHW',
                       'CMWH',
                       'CTGW',
                       'KWHW',
                       'MYWH',
                       'RWHW',
                       'SPWH',
                       'SWHW',
                       'SYWH',
                       'TWHW')
   and l.buy_qty_due > pr.qty_arrived
   and l.rowstate != 'Cancelled'

union all

--New Open PO
select p.order_no,
       l.line_no,
       l.release_no,
       (select c.order_no
          from IFSAPP.CUSTOMER_ORDER_TAB c
         where c.customer_po_no = p.order_no) REF_CO_NO,
       p.vendor_no,
       l.contract,
       (select s.area_code
          from IFSAPP.SHOP_DTS_INFO s
         where s.shop_code = l.contract) area_code,
       (select s.district_code
          from IFSAPP.SHOP_DTS_INFO s
         where s.shop_code = l.contract) district_code,
       l.part_no,
       l.description,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             l.part_no)) product_family,
       l.buy_qty_due qty_ordered,
       l.buy_qty_due qty_remain,
       trunc(p.order_date) order_date,
       l.wanted_delivery_date,
       l.planned_receipt_date,
       l.rowstate line_status,
       p.rowstate head_status,
       (select cl.rowstate
          from IFSAPP.CUSTOMER_ORDER_LINE_TAB cl
         where cl.demand_order_ref1 = l.order_no
           and cl.demand_order_ref2 = l.line_no
           and cl.demand_order_ref3 = l.release_no) co_status
  from IFSAPP.PURCHASE_ORDER_LINE_TAB l
 inner join IFSAPP.PURCHASE_ORDER_TAB p
    on l.order_no = p.order_no
 where p.rowstate = 'Released'
   and p.vendor_no in ('APWH',
                       'BBWH',
                       'BWHW',
                       'CMWH',
                       'CTGW',
                       'KWHW',
                       'MYWH',
                       'RWHW',
                       'SPWH',
                       'SWHW',
                       'SYWH',
                       'TWHW')
   and l.rowstate != 'Cancelled'
