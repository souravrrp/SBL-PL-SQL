select extract(year from t.arrival_date) "Year",
       extract(month from t.arrival_date) Period,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.part_no)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.part_no)) product_family_description,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(ifsapp.inventory_part_api.Get_Second_Commodity('SCOM',
                                                                                                 t.part_no)) comm_group_2,
       t.part_no,
       --IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL', t.vendor_no, 'Supplier') group_id,
       t.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(t.vendor_no) vendor_name,
       /*sum(t.qty_invoiced) qty_invoiced,*/
       sum(t.qty_arrived) qty_arrived
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
   and trunc(t.arrival_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and t.state != 'Cancelled'
 group by extract(year from t.arrival_date),
          extract(month from t.arrival_date),
          t.part_no,
          t.vendor_no
 order by extract(year from t.arrival_date),
          extract(month from t.arrival_date),
          t.part_no,
          t.vendor_no
