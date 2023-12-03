select t.customer_id,
       t.name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(t.customer_id) phone_no,
       ifsapp.CUSTOMER_INFO_ADDRESS_API.Get_Full_Address(t.customer_id, '1') address
  from ifsapp.CUSTOMER_INFO_TAB t
 where t.customer_id = '&cust_id'
