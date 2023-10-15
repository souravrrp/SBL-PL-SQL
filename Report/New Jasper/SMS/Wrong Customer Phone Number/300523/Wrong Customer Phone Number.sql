/* Formatted on 5/30/2023 4:00:22 PM (QP5 v5.381) */
SELECT cicm.customer_id                                        customer_no,
       ifsapp.customer_info_api.get_name (cicm.customer_id)    customer_name,
       cicm.VALUE                                              phone_number
  FROM ifsapp.customer_info_comm_method cicm
 WHERE     1 = 1
       AND (cicm.customer_id = $P{CUSTOMER_NUMBER} or  $P{CUSTOMER_NUMBER} IS NULL)
       AND ( :p_customer_id IS NULL OR (cicm.customer_id = :p_customer_id))
       AND ( :p_customer_phone IS NULL OR (cicm.VALUE = :p_customer_phone))
       AND SUBSTR (cicm.VALUE, 0, 2) = '01'
       AND LENGTH (cicm.VALUE) <> 11
       AND EXISTS
               (SELECT *
                  FROM ifsapp.customer_order_tab cot
                 WHERE     cot.customer_no = cicm.customer_id
                       AND TRUNC (cot.date_entered) BETWEEN NVL (
                                                                :p_date_from,
                                                                TRUNC (
                                                                    cot.date_entered))
                                                        AND NVL (
                                                                :p_date_to,
                                                                TRUNC (
                                                                    cot.date_entered)))