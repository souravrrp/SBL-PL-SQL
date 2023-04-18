SELECT hcot.contract,
       hcot.customer_no,
       ifsapp.customer_info_api.get_name (hcot.customer_no)
           customer_name,
       ifsapp.customer_info_comm_method_api.get_any_phone_no (hcot.customer_no)
           phone_number,
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
       ifsapp.get_sbl_order_vat_receipt (hcolt.order_no, hcolt.line_no, hcolt.rel_no, hcolt.line_item_no)
           vat_receipt_no
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
       AND ( hcot.customer_no = $P{CUSTOMER_NUMBER} or  $P{CUSTOMER_NUMBER} IS NULL)
       AND ( ifsapp.customer_info_comm_method_api.get_any_phone_no (hcot.customer_no) = $P{PHONE_NUMBER} or  $P{PHONE_NUMBER} IS NULL)
       AND ( ifsapp.serial_oem_conn_api.get_oem_no (cort.part_no, cort.serial_no) = $P{OEM_NO} or  $P{OEM_NO} IS NULL)
       AND ( ifsapp.get_sbl_order_vat_receipt (hcolt.order_no, hcolt.line_no, hcolt.rel_no, hcolt.line_item_no) = $P{VAT_RECEIPT_NO} or  $P{VAT_RECEIPT_NO} IS NULL)
       AND hcolt.date_entered BETWEEN $P{FROM_DATE}  and $P{TO_DATE}+1
       AND EXISTS
               (SELECT 1
                  FROM ifsapp.hpnret_auth_variation hav
                 WHERE     1 = 1
                       AND hav.account_no = hcot.order_no
                       AND hav.variation_db = 11
                       --AND hav.utilized = 1
                       AND TO_CHAR (hav.from_date, 'YYYY/MM/DD') =
                           TO_CHAR (hcolt.date_entered, 'YYYY/MM/DD'))