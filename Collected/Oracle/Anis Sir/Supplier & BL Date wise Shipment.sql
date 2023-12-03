--Supplier & BL Date wise Shipment
select IFSAPP.PURINV_SHIPMENTS_API.Get_Vendor_No(s.shipment_id) Supplier,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(IFSAPP.PURINV_SHIPMENTS_API.Get_Vendor_No(s.shipment_id)) Supplier_Name,
       to_char(IFSAPP.PURINV_SHIPMENTS_API.Get_BL_Date(s.shipment_id),
               'YYYY/MM/DD') BL_Date,
       IFSAPP.PURINV_SHIPMENTS_API.Get_BL_No(s.shipment_id) BL_No,
       IFSAPP.PURINV_SHIPMENTS_API.Get_Contract(s.shipment_id) Rec_Site,
       
       s.order_no,
       s.line_no,
       s.release_no,
       s.shipment_id,
       IFSAPP.PURCHASE_ORDER_LINE_PART_API.Get_Part_No(s.order_no,
                                                       s.line_no,
                                                       s.release_no) Part_No,
       s.received_qty,
       IFSAPP.PURCHASE_ORDER_LINE_PART_API.Get_Fbuy_Unit_Price(s.order_no,
                                                               s.line_no,
                                                               s.release_no) Fbuy_Unit_Price,
       s.rate_authorized rate,
       to_char(IFSAPP.PURINV_SHIPMENTS_API.Get_Created_Date(s.shipment_id), 'YYYY/MM/DD') Created_Date,
       IFSAPP.PURINV_SHIPMENTS_API.Get_Identity(s.shipment_id) Created_By,
       IFSAPP.PURINV_SHIPMENTS_API.Get_State(s.shipment_id) Status
  from IFSAPP.PURINV_SHIP_POLINE s
 where IFSAPP.PURINV_SHIPMENTS_API.Get_Vendor_No(s.shipment_id) like
       '&Supplier_Code'
   and IFSAPP.PURINV_SHIPMENTS_API.Get_BL_Date(s.shipment_id) between
       to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 order by 1, 3
