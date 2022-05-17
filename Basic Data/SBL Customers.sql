/* Formatted on 4/17/2022 3:03:25 PM (QP5 v5.381) */
SELECT cit.customer_id,
       cit.name           customer_name,
       cit.party_type     cust_party_type,
       cit.party          party_id,
       ciat.address_id,
       ciat.address,
       --ciat.address1,
       --ciat.address2,
       ciat.country
  --,cit.*
  --,ciat.*
  FROM ifsapp.customer_info_tab cit, ifsapp.customer_info_address_tab ciat
 WHERE     1 = 1
       AND cit.customer_id = ciat.customer_id
       AND cit.customer_id = '83';


--------------------------------------------------------------------------------

SELECT * FROM ifsapp.customer_info_tab;

SELECT * FROM ifsapp.customer_info_address_tab;


SELECT * FROM ifsapp.customer_info_address_type_tab;

SELECT * FROM ifsapp.customer_info_comm_method_tab;

SELECT * FROM ifsapp.customer_info_msg_setup_tab;

SELECT * FROM ifsapp.customer_info_our_id_tab;

SELECT * FROM ifsapp.customer_info_vat_tab;



------------------------------------view----------------------------------------

SELECT *
  FROM ifsapp.customer_info_address cia;

SELECT *
  FROM ifsapp.customer_info_comm_method cicm;

SELECT *
  FROM ifsapp.customer_info ci;