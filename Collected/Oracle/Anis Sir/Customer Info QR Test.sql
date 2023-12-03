--*****Customer Info
SELECT 
    T.CUSTOMER_ID CUST_ID,
    B.NAME        CUSTOMER_NAME,
    A.ADDRESS1    ADDRESS_LINE_01,
    A.ADDRESS2    ADDRESS_LINE_02,
    T.VALUE       TELEPHONE_NUMBER
FROM 
  IFSAPP.CUSTOMER_INFO_COMM_METHOD T,
  IFSAPP.CUSTOMER_INFO_ADDRESS     A,
  IFSAPP.CUSTOMER_INFO             B
WHERE 
  T.CUSTOMER_ID = A.CUSTOMER_ID AND 
  T.CUSTOMER_ID = B.CUSTOMER_ID AND 
  T.VALUE = '&telephone_number'


--*****Customer Info with AC No
SELECT 
    T.CUSTOMER_ID CUST_ID,
    B.NAME        CUSTOMER_NAME,
    C.ACCOUNT_NO,
    B.NIC_NO      NATIONAL_ID,
    A.ADDRESS1 ADDRESS_LINE_01,
    A.ADDRESS2 ADDRESS_LINE_02,
    T.VALUE    TELEPHONE_NUMBER
FROM 
  IFSAPP.CUSTOMER_INFO_COMM_METHOD T,
  IFSAPP.CUSTOMER_INFO_ADDRESS     A,
  IFSAPP.CUSTOMER_INFO             B,
  (SELECT H.ACCOUNT_NO,H.ID FROM IFSAPP.HPNRET_HP_HEAD H

  UNION ALL

  SELECT CO.ORDER_NO, CO.CUSTOMER_NO FROM  IFSAPP.HPNRET_CUSTOMER_ORDER CO) C
WHERE 
  T.CUSTOMER_ID = A.CUSTOMER_ID AND 
  T.CUSTOMER_ID = B.CUSTOMER_ID and 
  T.CUSTOMER_ID = C.ID AND 
  T.VALUE  ='&telephone_number'
ORDER BY T.CUSTOMER_ID

--*****Test
select
    m.customer_id CUST_ID,
    ifsapp.customer_info_api.Get_Name(m.customer_id) CUSTOMER_NAME,
    (select a.address1 from ifsapp.CUSTOMER_INFO_ADDRESS a 
      where a.customer_id = m.customer_id) ADDRESS_LINE_01,
    (select a.address2 from ifsapp.CUSTOMER_INFO_ADDRESS a 
      where a.customer_id = m.customer_id) ADDRESS_LINE_02,
    ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(m.customer_id) TELEPHONE_NUMBER,
    IFSAPP.CUSTOMER_INFO_API.Get_NIC_No(m.customer_id) NIC_NO
from
  IFSAPP.CUSTOMER_INFO_COMM_METHOD M
where
  --m.value  like '&telephone_number' and
  ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(m.customer_id) like '&telephone_number' and
  --(IFSAPP.CUSTOMER_INFO_API.Get_NIC_No(m.customer_id) is null or
  IFSAPP.CUSTOMER_INFO_API.Get_NIC_No(m.customer_id) like '&nic_no'
