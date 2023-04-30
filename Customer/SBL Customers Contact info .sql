/* Formatted on 3/21/2023 9:53:26 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.customer_info_comm_method cicm
 WHERE 1 = 1 
 --AND cicm.customer_id = :p_customer_id
 and (:p_customer_id is null or (cicm.customer_id = :p_customer_id))
 and (:p_customer_phone is null or (cicm.VALUE = :p_customer_phone))
 ;

SELECT IFSAPP.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No (2701186)    phone_number
  FROM DUAL;

-------------------------------------------------------------------------------

--IFSAPP.CUSTOMER_INFO_COMM_METHOD_API.Get_Default_Phone
