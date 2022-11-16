/* Formatted on 11/8/2022 12:31:50 PM (QP5 v5.381) */
SELECT si.supplier_id,
       si.NAME
           "Supplier (Vendor) Name",
          ifsapp.supplier_info_address_api.get_address1 (sia.supplier_id, 1)
       || ','
       || ifsapp.supplier_info_address_api.get_address2 (sia.supplier_id, 1)
           "Supplier (Vendor)  Address",
       sivt.vat_no
           bin_number
  FROM ifsapp.supplier_info          si,
       ifsapp.supplier_info_address  sia,
       ifsapp.supplier_info_vat_tab  sivt
 WHERE     1 = 1
       AND si.supplier_id = sivt.supplier_id
       AND si.supplier_id = sia.supplier_id;