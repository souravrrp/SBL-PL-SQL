/* Formatted on 2/23/2023 8:56:13 AM (QP5 v5.381) */
SELECT cit.name,
       cit.customer_id,
       cit.creation_date,
       cit.party_type,
       ifsapp.cust_ord_customer_api.get_cust_grp(cit.customer_id) stat_group
  --,CIT.*
  FROM customer_info_tab cit
 WHERE     1 = 1
       and (:p_customer_id is null or (cit.customer_id = :p_customer_id))
       AND (   :p_customer_no IS NULL
            OR (UPPER (cit.customer_id) LIKE UPPER ('%' || :p_customer_no || '%')))
       --AND customer_id = 'W0002991-2'
       AND (   :p_customer_name IS NULL
            OR (UPPER (cit.name) LIKE UPPER ('%' || :p_customer_name || '%')));