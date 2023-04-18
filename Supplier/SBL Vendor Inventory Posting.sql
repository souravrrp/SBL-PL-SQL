/* Formatted on 4/3/2023 10:44:37 AM (QP5 v5.381) */
SELECT iart.company,
       iart.identity        supplier_id,
       iart.invoice_id,
       iart.item_id,
       iart.row_id,
       iart.line_ref,
       iart.curr_amount     amount,
       iart.posting_type,
       iart.code_a          gl_code,
       iart.code_b          site_code,
       iart.text
  FROM ifsapp.inv_accounting_row_tab iart
 WHERE     iart.company = 'SBL'
       AND iart.party_type = 'SUPPLIER'
       and (:p_supplier_id is null or (iart.identity = :p_supplier_id))
       AND (   ifsapp.identity_invoice_info_api.get_group_id ('SBL',
                                                              iart.identity,
                                                              'Supplier') =
               '0'
            OR (   iart.identity LIKE 'W000%'
                OR iart.identity LIKE 'S000%'
                OR iart.identity LIKE 'IT0%'
                OR iart.identity LIKE 'WIT0%'
                OR iart.identity LIKE 'I000%'));