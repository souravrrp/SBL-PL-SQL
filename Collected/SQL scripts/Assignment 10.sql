select c.customer_id AS cust_no,
       c.name as cust_name,
       cad.country_db as country_code,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(c.customer_id) CUST_MOBILE_NO,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(cad.customer_id, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(cad.customer_id, 1) CUST_ADD
from ifsapp.customer_info c
inner join ifsapp.customer_info_address cad
on c.customer_id=cad.customer_id;

select s.supplier_id as sup_no,
       sad.country_db as country_code,
       IFSAPP.SUPPLIER_INFO_ADDRESS_API.Get_Address1(sad.supplier_id, 1) SUP_ADD1,
       IFSAPP.SUPPLIER_INFO_ADDRESS_API.Get_Address2(sad.supplier_id, 1) SUP_ADD2,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(S.supplier_id) SUP_PHONE
       
from ifsapp.supplier_info s 
inner join ifsapp.supplier_info_address sad
on s.supplier_id=sad.supplier_id;
       

       
