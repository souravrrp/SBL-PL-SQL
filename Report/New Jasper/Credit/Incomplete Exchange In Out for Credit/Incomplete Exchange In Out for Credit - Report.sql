/* Formatted on 11/23/2023 10:48:22 AM (QP5 v5.381) */
  SELECT hcot.contract,
         hcot.customer_no,
         ifsapp.customer_info_api.get_name (hcot.customer_no)    customer_name,
         ifsapp.customer_info_comm_method_api.get_any_phone_no (
             hcot.customer_no)                                   phone_number,
         hcot.order_no                                           order_no,
         hcot.date_entered                                       sale_date,
         hav.from_date,
         hav.TO_DATE,
         hav.TO_DATE - hav.from_date                             duration
    FROM ifsapp.hpnret_auth_variation hav, ifsapp.customer_order_tab hcot
   WHERE     1 = 1
         AND hav.account_no = hcot.order_no
         AND SYSDATE BETWEEN TRUNC (hav.from_date) AND TRUNC (hav.TO_DATE)
         AND hav.remarks LIKE '%Ex%In%Out%'
         AND hav.user_id = 'RUBEL0705'
         AND hav.utilized = '0'
         AND hav.STATE<>'Cancelled'
         AND hav.variation_db IN (11, 2)
         AND ( :p_order_no IS NULL OR (hcot.order_no = :p_order_no))
         AND NOT EXISTS
                 (SELECT *
                    FROM ifsapp.hpnret_hp_dtl_tab hhdt
                   WHERE     hhdt.rowstate = 'ExchangedIn'
                         AND hhdt.account_no = hcot.order_no)
ORDER BY hav.from_date;