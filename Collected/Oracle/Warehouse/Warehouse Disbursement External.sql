--***** Warehouse Disbursement External
select r.trip_no,
       r.release_no,
       r.order_no,
       r.line_no,
       r.rel_no,
       r.line_item_no,
       t.contract "SOURCE",
       t.created_date,
       t.delevery_date,
       t.act_delivery_date,
       t.rowstate,
       t.gate_pass_no,
       r.vat_receipt_no,
       r.debit_note_no,
       n.delnote_no,
       p.po_order_no,
       p.po_line_no,
       p.po_rel_no,
       p.oe_order_no,
       p.oe_line_no,
       p.oe_rel_no,
       p.oe_line_item_no,
       p.qty_on_order,
       r.actual_qty_reserved qty_delivered,
       l.catalog_no part_no,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(t.contract,
                                                                                                             l.catalog_no)) product_family,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(t.contract,
                                                                                                         l.catalog_no)) brand,
       IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Customer_No(p.oe_order_no,
                                                      p.oe_line_no,
                                                      p.oe_rel_no,
                                                      p.oe_line_item_no) customer_no,
       IFSAPP.CUST_ORD_CUSTOMER_API.Get_Name(IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Customer_No(p.oe_order_no,
                                                                                            p.oe_line_no,
                                                                                            p.oe_rel_no,
                                                                                            p.oe_line_item_no)) cust_name,
       IFSAPP.CUST_ORD_CUSTOMER_API.Get_Cust_Grp(IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Customer_No(p.oe_order_no,
                                                                                                p.oe_line_no,
                                                                                                p.oe_rel_no,
                                                                                                p.oe_line_item_no)) cust_grp,
       IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Ship_Addr_No(p.oe_order_no,
                                                       p.oe_line_no,
                                                       p.oe_rel_no,
                                                       p.oe_line_item_no) Ship_Addr_No,
       /*IFSAPP.CUST_ORD_CUSTOMER_ADDRESS_API.Get_Address1(IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Customer_No(p.oe_order_no,
                                                                                                        p.oe_line_no,
                                                                                                        p.oe_rel_no,
                                                                                                        p.oe_line_item_no),
                                                         IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Ship_Addr_No(p.oe_order_no,
                                                                                                         p.oe_line_no,
                                                                                                         p.oe_rel_no,
                                                                                                         p.oe_line_item_no)) Address1,
       IFSAPP.CUST_ORD_CUSTOMER_ADDRESS_API.Get_Address2(IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Customer_No(p.oe_order_no,
                                                                                                        p.oe_line_no,
                                                                                                        p.oe_rel_no,
                                                                                                        p.oe_line_item_no),
                                                         IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Ship_Addr_No(p.oe_order_no,
                                                                                                         p.oe_line_no,
                                                                                                         p.oe_rel_no,
                                                                                                         p.oe_line_item_no)) Address2,*/
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Full_Address(IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Customer_No(p.oe_order_no,
                                                                                                        p.oe_line_no,
                                                                                                        p.oe_rel_no,
                                                                                                        p.oe_line_item_no),
                                                         IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Ship_Addr_No(p.oe_order_no,
                                                                                                         p.oe_line_no,
                                                                                                         p.oe_rel_no,
                                                                                                         p.oe_line_item_no)) Full_Address
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
 inner join IFSAPP.CUSTOMER_ORDER_PUR_ORDER p
    on l.demand_order_ref1 = p.po_order_no
   and l.demand_order_ref2 = p.po_line_no
   and l.demand_order_ref3 = p.po_rel_no
 inner join IFSAPP.WARE_HOUSE_INFO w
    on t.contract = w.ware_house_name
 where t.rowstate in ('Closed', 'Delivered')
   and t.delevery_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
/*t.trip_no = 442820*/
/*r.vat_receipt_no = 3586319*/
/*t.debit_note_no = 3586319*/
/*p.po_order_no = 'W-75923'*/
/*r.order_no = 'SWH-R135653'*/
 order by 1, 2
