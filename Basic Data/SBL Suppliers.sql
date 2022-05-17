/* Formatted on 4/11/2022 9:23:00 AM (QP5 v5.381) */
SELECT si.supplier_id
           AS sup_no,
       sia.country_db
           AS country_code,
       ifsapp.supplier_info_address_api.get_address1 (sia.supplier_id, 1)
           sup_add1,
       ifsapp.supplier_info_address_api.get_address2 (sia.supplier_id, 1)
           sup_add2,
       ifsapp.customer_info_comm_method_api.get_any_phone_no (si.supplier_id)
           sup_phone
  FROM ifsapp.supplier_info si, ifsapp.supplier_info_address sia
 WHERE 1 = 1 AND si.supplier_id = sia.supplier_id;