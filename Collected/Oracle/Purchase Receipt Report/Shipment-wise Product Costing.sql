--***** Shipment-wise Product Costing
select l.shipment_id,
       l.order_no,
       l.line_no,
       l.release_no,
       to_char(s.shipment_date, 'YYYY/MM/DD') shipment_date,
       IFSAPP.PURCHASE_ORDER_API.Get_Vendor_No(l.order_no) vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(IFSAPP.PURCHASE_ORDER_API.Get_Vendor_No(l.order_no)) vendor_name,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Part_No(l.order_no,
                                                  l.line_no,
                                                  l.release_no) part_no,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Description(l.order_no,
                                                      l.line_no,
                                                      l.release_no) part_desc,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         IFSAPP.PURCHASE_ORDER_LINE_API.Get_Part_No(l.order_no,
                                                                                                                                                    l.line_no,
                                                                                                                                                    l.release_no))) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             IFSAPP.PURCHASE_ORDER_LINE_API.Get_Part_No(l.order_no,
                                                                                                                                                        l.line_no,
                                                                                                                                                        l.release_no))) product_family,
       l.received_qty,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Fbuy_Unit_Price(l.order_no,
                                                          l.line_no,
                                                          l.release_no) Fbuy_Unit_Price,
       s.curr_rate,
       (IFSAPP.PURCHASE_ORDER_LINE_API.Get_Fbuy_Unit_Price(l.order_no,
                                                           l.line_no,
                                                           l.release_no) *
       s.curr_rate) unit_price,
       /*IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(l.order_no,
       l.line_no,
       l.release_no) Buy_Unit_Price,*/
       l.charge_amt,
       decode(l.received_qty, 0, 0, (l.charge_amt / l.received_qty)) unit_charge_amt,
       decode(l.received_qty,
              0,
              0,
              round(IFSAPP.PURCHASE_ORDER_LINE_API.Get_Fbuy_Unit_Price(l.order_no,
                                                                       l.line_no,
                                                                       l.release_no) *
                    s.curr_rate + (l.charge_amt / l.received_qty),
                    2)) unit_cost,
       s.created_date,
       IFSAPP.PURCHASE_ORDER_API.Get_Lc_No(l.order_no) LC_NO,
       s.bl_no,
       s.bl_date,
       s.note,
       s.cinv_no,
       s.cinv_date,
       /*(select r.grn_no
          from IFSAPP.PURCHASE_RECEIPT_NEW r
         where r.shipment_id = l.shipment_id
           and r.order_no = l.order_no
           and r.line_no = l.line_no
           and r.release_no = l.release_no
           and r.state = 'Received') grn_no,*/
       s.state,
       l.state line_state
  from IFSAPP.PURINV_SHIP_POLINE l
 inner join IFSAPP.PURINV_SHIPMENTS s
    on l.shipment_id = s.shipment_id
 where /*trunc(s.shipment_date) between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and*/ s.bl_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM',
                                                         IFSAPP.PURCHASE_ORDER_LINE_API.Get_Part_No(l.order_no,
                                                                                                    l.line_no,
                                                                                                    l.release_no)) not in
       ('RBOOK', 'GIFT VOUCHER')
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Part_No(l.order_no,
                                                                                                  l.line_no,
                                                                                                  l.release_no)) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM',
                                                      IFSAPP.PURCHASE_ORDER_LINE_API.Get_Part_No(l.order_no,
                                                                                                 l.line_no,
                                                                                                 l.release_no)) not like
       'S-%'
   /*and ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             IFSAPP.PURCHASE_ORDER_LINE_API.Get_Part_No(l.order_no,
                                                                                                                                                        l.line_no,
                                                                                                                                                        l.release_no))) in
       ('REFRIGERATOR-DIRECT-COOL',
        'REFRIGERATOR-SIDE-BY-SIDE',
        'REFRIGERATOR-NOFROST',
        'REFRIGERATOR-FREEZER',
        'REFRIGERATOR-SEMI-COMM')*/
 order by l.shipment_id, l.order_no, l.line_no, l.release_no
