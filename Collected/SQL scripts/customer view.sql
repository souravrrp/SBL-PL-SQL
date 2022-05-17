CREATE OR REPLACE VIEW sbl_vat_customer AS
select ''CUST_ID,
       c.customer_id AS cust_no,
       c.name as cust_name,
       ''ORG_CODE,
       cad.country_db as country_code,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(c.customer_id) CUST_MOBILE_NO,
       ''CUST_EMAIL,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(cad.customer_id, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(cad.customer_id, 1) CUST_ADD,
       ''CONTACT_PERSON,
       ''CONTACT_PERSON_MOBILE_NO,
       ''BIN_NO,
       ''TIN_NO,
       ''VAT_REG_NO,
       ''NID
from ifsapp.customer_info c
inner join ifsapp.customer_info_address cad
on c.customer_id=cad.customer_id;
