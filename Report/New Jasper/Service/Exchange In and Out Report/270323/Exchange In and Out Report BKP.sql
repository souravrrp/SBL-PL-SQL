SELECT hcot.contract,
       hcot.customer_no,
       ifsapp.customer_info_api.get_name (hcot.customer_no)                    customer_name,
       hcot.order_no                                                           order_no_in,
       hcolt.date_entered                                                      sales_date,
       NVL (hcolt.note, hcot.remarks)                                          ex_in_out,
       hcolt.order_no                                                          order_no_out,
       hcolt.part_no,
       rmlt.rma_no                                                             rma_no,
       cort.serial_no,
       ifsapp.serial_oem_conn_api.get_oem_no (cort.part_no, cort.serial_no)    oem_no,
       ifsapp.get_sbl_order_vat_receipt (hcolt.order_no,
                                         hcolt.line_no,
                                         hcolt.rel_no,
                                         hcolt.line_item_no)
           vat_receipt_no
  FROM ifsapp.hpnret_customer_order_tab       hcot,
       ifsapp.return_material_line_tab        rmlt,
       ifsapp.hpnret_cust_order_line_tab      hcolt,
       ifsapp.customer_order_reservation_tab  cort
 WHERE  rmlt.order_no = hcot.order_no(+)
       AND hcot.customer_no = hcolt.owning_customer_no
       AND hcolt.contract = cort.contract(+)
       AND hcolt.order_no = cort.order_no(+)
       AND hcolt.part_no = cort.part_no(+)
       AND UPPER (NVL (hcolt.note, hcot.remarks)) LIKE
               UPPER ('%SCR-Ex-In%Out%')
       AND hcolt.date_entered BETWEEN $P{FROM_DATE}  and $P{TO_DATE}+1
       AND EXISTS
               (SELECT 1
                  FROM ifsapp.hpnret_auth_variation hav
                 WHERE     hcot.order_no = hav.account_no
                       AND hav.variation_db = 11
                       --AND hav.utilized = 1
                       AND TO_CHAR (hav.from_date, 'YYYY/MM/DD') =
                           TO_CHAR (hcolt.date_entered, 'YYYY/MM/DD'))