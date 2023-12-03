--***** Received Products in a duration
select i.part_no,
       i.serial_no,
       IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(i.part_no, i.serial_no) oem_no,
       i.part_no || '-' || i.serial_no mch_code,
       i.vendor_no,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(i.vendor_no) vendor_name,
       i.receipt_date
  from IFSAPP.INVENTORY_PART_IN_STOCK_TAB i
 where i.part_no = /*'SRTV-SLE23D1200TC'*/ /*'SRTV-SLE32D1200TC'*/ /*'SRREF-SINGER-BCD-198R-RG'*/ /*'SGTV-UA43N5300ARSER'*/ 'SRTV-SLE32E3HDTV'
       /*like '%TV-%'*/
   and IFSAPP.PART_CATALOG_API.Get_Serial_Tracking_Code_Db(i.part_no) =
               'SERIAL TRACKING'
   and IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL',
                                                     i.vendor_no,
                                                     'Supplier') = '0'
   and trunc(i.receipt_date) between to_date('2018/1/1', 'YYYY/MM/DD') and to_date('2018/2/28', 'YYYY/MM/DD')
/*and t.serial_no = '56148'*/
