--CUSTOMER VIEW
CREATE OR REPLACE VIEW sbl_vat_customer AS
select ''CUST_ID,
       c.customer_id AS cust_no,
       c.name as cust_name,
       ''ORG_CODE,
       c.country_db as country_code,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(c.customer_id) CUST_MOBILE_NO,
       ''CUST_EMAIL,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(c.customer_id, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(c.customer_id, 1) CUST_ADD,
       ''CONTACT_PERSON,
       ''CONTACT_PERSON_MOBILE_NO,
       ''BIN_NO,
       ''TIN_NO,
       ''VAT_REG_NO,
       ''NID
from ifsapp.customer_info c;

--SUPPLIER VIEW
create or replace view sbl_vat_supplier as
select ''SUP_ID,
       s.supplier_id as sup_no,
       s.name as SUP_DESC,
       s.country_db as country_code,
       IFSAPP.SUPPLIER_INFO_ADDRESS_API.Get_Address1(s.supplier_id, 1) SUP_ADD1,
       IFSAPP.SUPPLIER_INFO_ADDRESS_API.Get_Address2(s.supplier_id, 1) SUP_ADD2,
       ''SUP_CITY,
       ifsapp.SUPPLIER_INFO_COMM_METHOD_API.Get_Any_Phone_No(S.supplier_id) SUP_PHONE,
       ''SUP_EMAIL,
       ''SUP_CONT_PERSON,
       ''SUP_CONT_PHONE,
       ''BIN_NO,
       ''TIN_NO,
       ''VAT_REG_NO,
       ''NID
from ifsapp.supplier_info s;

--CURRENCY
select ''CUR_ID,
       c.CURRENCY_CODE,
       c.DESCRIPTION,
       ''CUR_ORIGIN_CODE,
       ''CUR_SYMBOL
FROM CURRENCY_CODE c;

--MEASUREMENT UNIT
SELECT ''MSR_UNIT_ID,
       u.UNIT_CODE, 
       u.DESCRIPTION 
FROM ISO_UNIT_TAB u;


