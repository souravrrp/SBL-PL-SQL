--Local Purchase
select R.order_no,
       R.line_no,
       R.release_no,
       R.receipt_no,
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Pi_No(R.order_no,
                                                R.line_no,
                                                R.release_no) PI_NO,
       R.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(R.vendor_no) vendor_name,
       R.contract,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         R.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             R.part_no)) product_family,
       R.part_no,
       R.description,
       IFSAPP.PURCHASE_ORDER_LINE_PART_API.Get_Buy_Qty_Due(R.order_no,
                                                           R.line_no,
                                                           R.release_no) po_qty,
       /*R.qty_arrived,*/
       IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(R.order_no,
                                                         R.line_no,
                                                         R.release_no) Buy_Unit_Price,
       (IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price(R.order_no,
                                                          R.line_no,
                                                          R.release_no) *
       IFSAPP.PURCHASE_ORDER_LINE_PART_API.Get_Buy_Qty_Due(R.order_no,
                                                            R.line_no,
                                                            R.release_no)) Invoice_Amoount,
       to_char(R.arrival_date, 'YYYY/MM/DD') grn_date,
       r.grn_no,
       R.state
  from IFSAPP.PURCHASE_RECEIPT_NEW R
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     R.vendor_no,
                                                     'Supplier') = '0'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', R.part_no) !=
       'RBOOK'
      /*and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', R.part_no) !=
          'RAW'
      and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', R.part_no) not like
          'S-%'*/
   and trunc(R.arrival_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and R.state != 'Cancelled'
   and R.vendor_no not in
       ('XLBD-SACF', 'XLBD-SRAV', 'XLBD-SRFR' /*, 'XLBD-IAL'*/)
      /*and R.contract = 'CTGW'*/ /*'SACF'*/ /*'SAVF'*/
      /*and R.order_no like '&order_no'*/
   and substr(R.order_no, 1, 2) like 'L-%'
/*and R.part_no in
('SRSM-TABLE', 'SRSM- WOODEN COVER', 'SRSM-STAND-METAL-STEEL')*/
/*and IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                  R.part_no)) =
'Beko'*/
 order by 1, 2
