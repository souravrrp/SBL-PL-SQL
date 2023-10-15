/* Formatted on 5/30/2023 3:52:22 PM (QP5 v5.381) */
SELECT cicm.customer_id,
       ifsapp.customer_info_api.get_name (cicm.customer_id)    customer_name,
       cicm.VALUE                                              phone_number
  FROM ifsapp.customer_info_comm_method cicm
 WHERE     1 = 1
       --AND cicm.customer_id = :p_customer_id
       AND ( :p_customer_id IS NULL OR (cicm.customer_id = :p_customer_id))
       AND ( :p_customer_phone IS NULL OR (cicm.VALUE = :p_customer_phone))
       AND SUBSTR (cicm.VALUE, 0, 2) = '01'
       AND LENGTH (cicm.VALUE) <> 11