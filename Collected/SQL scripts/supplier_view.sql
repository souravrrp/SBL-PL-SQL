create or replace view sbl_vat_supplier as
select ''SUP_ID,
       s.supplier_id as sup_no,
       ''SUP_DESC,
       sad.country_db as country_code,
       IFSAPP.SUPPLIER_INFO_ADDRESS_API.Get_Address1(sad.supplier_id, 1) SUP_ADD1,
       IFSAPP.SUPPLIER_INFO_ADDRESS_API.Get_Address2(sad.supplier_id, 1) SUP_ADD2,
       ''SUP_CITY,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(S.supplier_id) SUP_PHONE,
       ''SUP_EMAIL,
       ''SUP_CONT_PERSON,
       ''SUP_CONT_PHONE,
       ''BIN_NO,
       ''TIN_NO,
       ''VAT_REG_NO,
       ''NID

       
from ifsapp.supplier_info s 
inner join ifsapp.supplier_info_address sad
on s.supplier_id=sad.supplier_id;
