/* Formatted on 4/4/2023 2:12:24 PM (QP5 v5.381) */
SELECT hcot.contract,
       hcot.customer_no,
       ifsapp.customer_info_api.get_name (hcot.customer_no)
           customer_name,
       hcot.order_no
           order_no_in,
       hcot.date_entered
           original_sale_date,
       NVL (
           (SELECT MAX (hcpht.vat_receipt)     vat_receipt
              FROM ifsapp.hpnret_co_pay_head_tab  hcpht,
                   ifsapp.hpnret_co_pay_dtl_tab   hcpdt
             WHERE     hcpht.pay_no = hcpdt.pay_no
                   AND hcpdt.order_no = hcot.order_no),
           (SELECT MAX (hprht.vat_receipt)     vat_receipt
              FROM ifsapp.hpnret_hp_dtl_tab            hhdt,
                   ifsapp.hpnret_pay_receipt_head_tab  hprht
             WHERE     1 = 1
                   AND hprht.account_no = hhdt.account_no
                   AND hhdt.reference_co = hcot.order_no))
           in_vat_receipt_no,
       hcolt.note
           ex_in_out,
       hcolt.order_no
           order_no_out,
       hcolt.date_entered
           sales_date,
       hcolt.part_no,
       cort.serial_no,
       ifsapp.serial_oem_conn_api.get_oem_no (cort.part_no, cort.serial_no)
           oem_no,
       ifsapp.get_sbl_order_vat_receipt (hcolt.order_no,
                                         hcolt.line_no,
                                         hcolt.rel_no,
                                         hcolt.line_item_no)
           vat_receipt_no
  --,hcolt.*
  FROM ifsapp.hpnret_cust_order_line_tab      hcolt,
       ifsapp.customer_order_reservation_tab  cort,
       ifsapp.hpnret_customer_order_tab       hcot
 WHERE     1 = 1
       AND hcolt.owning_customer_no = hcot.customer_no
       AND hcolt.contract = cort.contract
       AND hcolt.order_no = cort.order_no
       AND hcolt.line_no = cort.line_no
       AND hcolt.rel_no = cort.rel_no
       AND hcolt.line_item_no = cort.line_item_no
       AND hcolt.part_no = cort.part_no
       AND UPPER (hcolt.note) LIKE UPPER ('%SCR-Ex-In%Out%')
       AND (   :p_order_no IS NULL
            OR (UPPER (hcolt.order_no) = UPPER ( :p_order_no)))
       AND (   :p_customer_no IS NULL
            OR (hcolt.owning_customer_no = :p_customer_no))
       AND TRUNC (hcolt.date_entered) BETWEEN NVL (
                                                  :p_date_from,
                                                  TRUNC (hcolt.date_entered))
                                          AND NVL (
                                                  :p_date_to,
                                                  TRUNC (hcolt.date_entered))
       AND EXISTS
               (SELECT 1
                  FROM ifsapp.hpnret_auth_variation hav
                 WHERE     1 = 1
                       AND hav.account_no = hcot.order_no
                       AND hav.variation_db = 11
                       --AND hav.utilized = 1
                       AND TO_CHAR (hav.from_date, 'YYYY/MM/DD') =
                           TO_CHAR (hcolt.date_entered, 'YYYY/MM/DD'));