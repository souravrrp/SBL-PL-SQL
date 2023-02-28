/* Formatted on 2/23/2023 8:56:13 AM (QP5 v5.381) */
SELECT name,
       customer_id,
       creation_date,
       party_type
  --,CIT.*
  FROM customer_info_tab cit
 WHERE     1 = 1
       and (:p_customer_id is null or (cit.customer_id = :p_customer_id))
       --AND customer_id = 'W0002991-2'
       AND (   :p_customer_name IS NULL
            OR (UPPER (cit.name) LIKE UPPER ('%' || :p_customer_name || '%')));