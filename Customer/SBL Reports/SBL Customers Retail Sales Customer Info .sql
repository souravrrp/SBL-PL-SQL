/* Formatted on 4/10/2023 3:15:13 PM (QP5 v5.381) */
SELECT cit.customer_id,
       cit.name,
       ifsapp.customer_info_comm_method_api.get_any_phone_no (
           cit.customer_id)    phone_number
  FROM customer_info_tab cit
 WHERE     1 = 1
       AND cit.party_type = 'CUSTOMER'
       AND EXISTS
               (SELECT 1
                  FROM sbl_jr_sales_dtl_inv di, shop_dts_info sdi
                 WHERE     di.site = sdi.shop_code
                       AND di.customer_no = cit.customer_id
                       AND ifsapp.inventory_part_api.get_prime_commodity (
                               di.site,
                               di.product_code) IN
                               ('REF', 'CTV')
                       AND TRUNC (sales_date) BETWEEN NVL (
                                                          :p_date_from,
                                                          TRUNC (sales_date))
                                                  AND NVL (
                                                          :p_date_to,
                                                          TRUNC (sales_date)));

--------------------------------------------------------------------------------

SELECT cit.customer_id,
       cit.name,
       ifsapp.customer_info_comm_method_api.get_any_phone_no (
           cit.customer_id)    phone_number
  FROM ifsapp.customer_info_tab cit
 WHERE     1 = 1
       AND cit.party_type = 'CUSTOMER'
       AND EXISTS
               (SELECT 1
                  FROM ifsapp.customer_order_line_tab  di,
                       ifsapp.shop_dts_info            sdi
                 WHERE     di.CONTRACT = sdi.shop_code
                       AND di.OWNING_CUSTOMER_NO = cit.customer_id
                       AND ifsapp.inventory_part_api.Get_Prime_Commodity (
                               'SCOM',
                               di.catalog_no) IN
                               ('REF', 'CTV')
                       AND TRUNC (date_entered) BETWEEN NVL (
                                                            :p_date_from,
                                                            TRUNC (
                                                                date_entered))
                                                    AND NVL (
                                                            :p_date_to,
                                                            TRUNC (
                                                                date_entered)));

--------------------------------------------------------------------------------

SELECT DISTINCT
       COT.customer_no,
       ifsapp.customer_info_api.get_name (di.customer_no)                        customer_name,
       ifsapp.customer_info_comm_method_api.get_any_phone_no (di.customer_no)    phone_number
  FROM ifsapp.customer_order_tab       cot,
       ifsapp.customer_order_line_tab  di,
       ifsapp.shop_dts_info            sdi
 WHERE     di.contract = sdi.shop_code
       AND cot.order_no = DI.order_no
       AND ifsapp.inventory_part_api.get_prime_commodity ('SCOM',
                                                          di.catalog_no) IN
               ('REF', 'CTV')
       AND TRUNC (cot.date_entered) BETWEEN NVL ( :p_date_from,
                                                 TRUNC (cot.date_entered))
                                        AND NVL ( :p_date_to,
                                                 TRUNC (cot.date_entered))
       AND EXISTS
               (SELECT 1
                  FROM customer_info_tab cit
                 WHERE     1 = 1
                       AND cit.party_type = 'CUSTOMER'
                       AND COT.customer_no = cit.customer_id)