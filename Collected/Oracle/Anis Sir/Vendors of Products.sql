--***** Vendors of Products
select s.part_no,
       s.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(s.vendor_no) vendor_name
  from PURCHASE_PART_SUPPLIER s
 where IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     s.vendor_no,
                                                     'Supplier') = '0'
   and IFSAPP.INVENTORY_PART_API.Get_Part_Product_Family('SCOM', s.part_no) not in
       ('RBOOK', 'GIFT VOUCHER')
   and ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM', s.part_no) !=
       'RAW'
   and ifsapp.inventory_part_api.Get_Second_Commodity('SCOM', s.part_no) not like
       'S-%'
   /*and s.part_no like '%BOOK%'*/
 group by s.part_no, s.vendor_no
 order by s.part_no
