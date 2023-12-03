/*IFSAPP.PURCHASE_ORDER
IFSAPP.PURCHASE_ORDER_LINE_PART
IFSAPP.PURCHASE_RECEIPT_NEW
IFSAPP.PURCHASE_RECEIPT_HIST
IFSAPP.IDENTITY_INVOICE_INFO_API
IFSAPP.SUPPLIER_INFO
IFSAPP.IDENTITY_INVOICE_INFO*/

--select distinct t.state from PURCHASE_RECEIPT_NEW t

--*****
select 
    t.*,
    IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL', t.vendor_no, 'Supplier') group_id
from PURCHASE_RECEIPT_NEW t
where 
  --t.order_no like 'F-2113' and
  IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL', t.vendor_no, 'Supplier') = '0' and
  t.part_no like '&part_no' and
  t.part_no != 'RCPT-BOOK' and
  t.arrival_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD') and
  t.state not in 'Cancelled'

--*****Product wise Monthly Receive Quantity
select extract(year from t.arrival_date) "Year",
       extract(month from t.arrival_date) Period,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.part_no)) brand,
       --IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', t.part_no) Product_Family, 
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.part_no)) product_family_description,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(ifsapp.inventory_part_api.Get_Second_Commodity('SCOM',
                                                                                                 t.part_no)) comm_group_2,
       t.part_no,
       --IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL', t.vendor_no, 'Supplier') group_id,
       t.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(t.vendor_no) vendor_name,
       sum(t.qty_invoiced) qty_invoiced
  from PURCHASE_RECEIPT_NEW t
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     t.vendor_no,
                                                     'Supplier') = '0'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', t.part_no) not in
       ('RBOOK', 'GIFT VOUCHER')
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', t.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', t.part_no) not like
       'S-%'
   and t.part_no like '&part_no'
      --and t.order_no like 'F-2113' 
      --and t.part_no != 'RCPT-BOOK' 
   and trunc(t.arrival_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and t.state != 'Cancelled'
 group by extract(year from t.arrival_date),
          extract(month from t.arrival_date),
          t.part_no,
          t.vendor_no
--KKDB, KMCB, PMBB, THMB
