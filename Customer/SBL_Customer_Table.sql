/* Formatted on 3/19/2023 3:40:56 PM (QP5 v5.381) */
SELECT name,
       customer_id,
       creation_date,
       party_type,
       ifsapp.cust_ord_customer_api.get_cust_grp (cit.customer_id)    stat_group
  --,CIT.*
  FROM customer_info_tab cit
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (cit.customer_id = :p_customer_id))
       AND (   :p_customer_no IS NULL
            OR (UPPER (cit.customer_id) LIKE
                    UPPER ('%' || :p_customer_no || '%')))
       --AND customer_id = 'W0002991-2'
       AND (   :p_customer_name IS NULL
            OR (UPPER (cit.name) LIKE UPPER ('%' || :p_customer_name || '%')));

------------------------------------View----------------------------------------

SELECT *
  FROM ifsapp.customer_info ci
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (ci.customer_id = :p_customer_id));

SELECT *
  FROM ifsapp.customer_info_address cia
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (cia.customer_id = :p_customer_id));

SELECT *
  FROM ifsapp.cust_ord_customer_address_ent cocae
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (cocae.customer_id = :p_customer_id));

SELECT *
  FROM ifsapp.customer_info_vat civ
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (civ.customer_id = :p_customer_id));

SELECT *
  FROM ifsapp.customer_info_comm_method cicm
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (cicm.customer_id = :p_customer_id));

SELECT *
  FROM ifsapp.customer_info_msg_setup cims
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (cims.customer_id = :p_customer_id));

SELECT *
  FROM ifsapp.cust_ord_customer_ent coce
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (coce.customer_id = :p_customer_id));

SELECT *
  FROM ifsapp.identity_invoice_info iii
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (iii.IDENTITY = :p_customer_id));

------------------------------------Customer Group------------------------------

SELECT cust_grp customer_group, coct.*
  FROM cust_ord_customer_tab coct
 WHERE     1 = 1
       AND ( :p_customer_id IS NULL OR (coct.CUSTOMER_NO = :p_customer_id));


------------------------------api-----------------------------------------------
--ifsapp.customer_info_api
--ifsapp.customer_info_vat_api
