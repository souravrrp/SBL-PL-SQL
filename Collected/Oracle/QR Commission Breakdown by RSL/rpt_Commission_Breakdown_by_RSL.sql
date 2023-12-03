SELECT transaction_id,
       commission_receiver,
       d.entitlement_type,
       d.claim_id,
       d.commission_sales_type,
       d.collection_type,
       d.approved_amount,
       d.calculated_date,
       d.order_no,
       d.ord_line_no,
       d.ord_rel_no,
       d.receipt_no,
       d.approved_date,
       d.deduction_type,
       d.deduction_reason,
       d.deduction_amount,
       d.note
  FROM ifsapp.commission_value_detail d
 WHERE d.site = '&SITE'
   AND d.claim_id IN
       (SELECT claim_id
          FROM ifsapp.COMM_BONS_INCEN_CLAIM c
         WHERE c.site = '&SITE'
           AND c.entitlement_type LIKE '&ENTITLEMENTTYPE'
           AND c.series_id || c.invoice_no IN
               (SELECT a.ledger_item_series_id || a.ledger_item_id
                  FROM ifsapp.site_expenses_detail a, ifsapp.site_expenses b
                 WHERE b.contract = '&SITE'
                   AND a.company = b.company
                   AND a.exp_statement_id = b.exp_statement_id
                   AND UPPER(a.objstate) = 'APPROVED'
                   AND b.cash_account_type_db = 'BCB'
                   AND trunc(a.voucher_date) BETWEEN
                       (SELECT from_date
                          FROM ifsapp.hpnret_rsl r
                         WHERE r.sequence_no = '&RSL_NO') AND
                       (SELECT to_date
                          FROM ifsapp.hpnret_rsl rs
                         WHERE rs.sequence_no = '&RSL_NO')))
UNION ALL
SELECT transaction_id,
       commission_receiver,
       d.entitlement_type,
       d.claim_id,
       d.commission_sales_type,
       d.collection_type,
       d.approved_amount,
       d.calculated_date,
       d.order_no,
       d.ord_line_no,
       d.ord_rel_no,
       d.receipt_no,
       d.approved_date,
       d.deduction_type,
       d.deduction_reason,
       d.deduction_amount,
       d.note
  FROM ifsapp.commission_value_detail d
 WHERE d.site = '&SITE'
   AND d.claim_id IN
       (SELECT claim_id
          FROM ifsapp.COMM_BONS_INCEN_CLAIM c
         WHERE c.site = '&SITE'
           AND c.entitlement_type LIKE '&ENTITLEMENTTYPE'
           AND c.series_id || c.invoice_no IN
               (SELECT a.exp_lump_sum_trans_no || b.exp_statement_no
                  FROM ifsapp.site_expenses_detail a, ifsapp.site_expenses b
                 WHERE b.contract = '&SITE'
                   AND a.company = b.company
                   AND a.exp_statement_id = b.exp_statement_id
                   AND UPPER(a.objstate) = 'APPROVED'
                   AND a.transaction_code = 'BI001'
                   AND b.cash_account_type_db = 'BCB'
                   AND trunc(a.voucher_date) BETWEEN
                       (SELECT from_date
                          FROM ifsapp.hpnret_rsl r
                         WHERE r.sequence_no = '&RSL_NO') AND
                       (SELECT to_date
                          FROM ifsapp.hpnret_rsl rs
                         WHERE rs.sequence_no = '&RSL_NO')))
