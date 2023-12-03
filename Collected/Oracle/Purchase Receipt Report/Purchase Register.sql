--Purchase Register
select R.vendor_no VENDOR_CODE,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(R.vendor_no) vendor_name,
       trunc(R.arrival_date) DATE_OF_RECEIPT,
       R.part_no,
       R.description,
       R.qty_arrived QUANTITY,
       R.contract RECEIVE_SITE,
       R.order_no PO_NO,
       TRUNC(IFSAPP.PURCHASE_ORDER_API.Get_Order_Date(R.order_no)) PO_DATE,
       IFSAPP.Purchase_Order_Line_API.Get_Buy_Qty_Due(R.order_no,
                                                      R.line_no,
                                                      R.release_no) PO_QUANTITY /*,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         R.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             R.part_no)) product_family,
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
       R.line_no,
       R.release_no,
       R.receipt_no,
       IFSAPP.PURCHASE_ORDER_API.Get_Lc_No(R.order_no) LC_NO,
       R.grn_no,
       R.shipment_id,
       R.state*/
  from IFSAPP.PURCHASE_RECEIPT_NEW R
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     R.vendor_no,
                                                     'Supplier') = '0'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', R.part_no) !=
       'RBOOK'
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', R.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', R.part_no) not like
       'S-%'
   and trunc(R.arrival_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and R.state != 'Cancelled'
   and R.vendor_no not in
       ('XLBD-SACF', 'XLBD-SRAV', 'XLBD-SRFR'/*, 'XLBD-IAL'*/)
   /*and R.contract = \*'CTGW'*\*/ /*'SFRF'*/ /*'SACF'*/ /*'SAVF'*/
   /*and R.part_no is null*/
   /*and R.order_no like '&order_no'
and substr(R.order_no, 1, 2) like 'L-%'
and R.part_no in
    ('SRSM-TABLE', 'SRSM- WOODEN COVER', 'SRSM-STAND-METAL-STEEL')
and IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                      R.part_no)) =
    'Beko'*/
 order by 1, 4, 3, 8, 7