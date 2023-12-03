--***** Warehouse Disbursement Internal
select r.trip_no,
       r.release_no,
       r.order_no,
       r.line_no,
       r.rel_no,
       r.line_item_no,
       t.contract          "SOURCE",
       t.created_date,
       t.delevery_date,
       t.act_delivery_date,
       t.rowstate,
       t.gate_pass_no,
       r.vat_receipt_no,
       r.debit_note_no,
       n.delnote_no,
       l.demand_order_ref1 po_order_no,
       l.demand_order_ref2 po_line_no,
       l.demand_order_ref3 po_rel_no,
       /*p.oe_order_no,
       p.oe_line_no,
       p.oe_rel_no,
       p.oe_line_item_no,*/
       l.buy_qty_due qty_on_order,
       r.actual_qty_reserved qty_delivered,
       l.catalog_no part_no,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(t.contract,
                                                                                                             l.catalog_no)) product_family,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(t.contract,
                                                                                                         l.catalog_no)) brand,
       l.customer_no destination,
       IFSAPP.USER_GROUP_FINANCE_API.Get_User_Group_Description('SBL',
                                                                l.customer_no) Full_Address
  from IFSAPP.TRN_TRIP_PLAN_CO_LINE_TAB r
 inner join IFSAPP.TRN_TRIP_PLAN_TAB t
    on r.trip_no = t.trip_no
 inner join IFSAPP.CUSTOMER_ORDER_DELIVERY_TAB n
    on r.order_no = n.order_no
   and r.line_no = n.line_no
   and r.rel_no = n.rel_no
   and r.line_item_no = n.line_item_no
  left join IFSAPP.CUSTOMER_ORDER_LINE_TAB l
    on r.order_no = l.order_no
   and r.line_no = l.line_no
   and r.rel_no = l.rel_no
   and r.line_item_no = l.line_item_no
 inner join IFSAPP.WARE_HOUSE_INFO w
    on t.contract = w.ware_house_name
 where t.rowstate in ('Closed', 'Delivered')
   and ifsapp.purchase_order_line_api.Get_Demand_Order_No(l.demand_order_ref1,
                                                          l.demand_order_ref2,
                                                          l.demand_order_ref3) is null
   and t.delevery_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
/*t.trip_no = \*442820*\ 468469*/
/*r.vat_receipt_no = 3586319*/
/*t.debit_note_no = 3586319*/
/*p.po_order_no = 'W-75923'*/
/*r.order_no = 'SWH-R135653'*/
/*and l.customer_no = 'SAOS'*/ /*'WSMO'*/ /*'SCSM'*/ /*'DGNB'*/
 order by 1, 2
