create or replace view SBL_PURCHASE_REC_THR_IMP_CHG as
select R.order_no,
       R.line_no,
       R.release_no,
       R.receipt_no,
       R.shipment_id,
       R.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(R.vendor_no) vendor_name,
       R.contract,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         R.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             R.part_no)) product_family,
       R.part_no,
       R.description,
       trunc(R.arrival_date) arrival_date,
       IFSAPP.PURCHASE_ORDER_LINE_PART_API.Get_Buy_Qty_Due(R.order_no,
                                                           R.line_no,
                                                           R.release_no) order_qty,
       R.qty_arrived,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(R.order_no,
                                                         R.line_no,
                                                         R.release_no) Buy_Unit_Price,
       (IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(R.order_no,
                                                          R.line_no,
                                                          R.release_no) *
       R.qty_arrived) Total_Price,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Fbuy_Unit_Price(R.order_no,
                                                          R.line_no,
                                                          R.release_no) Fbuy_Unit_Price,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Currency_Rate(R.order_no,
                                                        R.line_no,
                                                        R.release_no) Currency_Rate,
       IFSAPP.PURINV_SHIP_POLINE_API.Get_Est_Chg_Per_Item(R.order_no,
                                                          R.line_no,
                                                          R.release_no,
                                                          R.shipment_id) Unit_Charge_Amt,
       IFSAPP.PURINV_SHIP_POLINE_API.Get_Charge_Amt(R.order_no,
                                                    R.line_no,
                                                    R.release_no,
                                                    R.shipment_id) Total_Charge_Amt,
       R.grn_no,
       to_char(s.bl_date, 'YYYY/MM/DD') bl_date,
       s.bl_no,
       IFSAPP.PURCHASE_ORDER_API.Get_Lc_No(R.order_no) LC_NO,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Pi_No(R.order_no,
                                                R.line_no,
                                                R.release_no) PI_NO,
       s.note file_no,
       s.cinv_no,
       R.state
  from IFSAPP.PURCHASE_RECEIPT_NEW R
 inner join IFSAPP.PURINV_SHIPMENTS S
    on r.shipment_id = s.shipment_id
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     R.vendor_no,
                                                     'Supplier') = '0'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family(R.contract,
                                                         R.part_no) not in
       ('RBOOK', 'GV')
   and R.state != 'Cancelled'
   and R.vendor_no not in
       ('XLBD-SACF', 'XLBD-SRAV', 'XLBD-SRFR', 'XLBD-IAL')
 order by 1, 2, 3, 4
