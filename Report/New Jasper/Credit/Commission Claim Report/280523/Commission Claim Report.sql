SELECT t.site,
         t.claim_id,
         t.order_no,
         t.ord_line_no,
         t.ord_rel_no,
         t.ord_line_item_no,
         t.receipt_no,
         t.commission_sales_type,
         t.collection_type,
         t.catalog_no,
         t.installment_amount,
         (SELECT t1.installment_amount
            FROM ifsapp.COMMISSION_VALUE_DETAIL t1
           WHERE     t1.transaction_id = t.org_transaction_id
                 AND t1.site = t.site
                 AND t1.catalog_no = t.catalog_no
                 AND t1.collection_type = 'INST'
                 AND t1.comm_calc_amount > 0
                 AND ROWNUM <= 1)
             org_installment_amount,
         t.comm_calc_amount,
         TO_CHAR (TRUNC (t.calculated_date), 'YYYY/MM/DD')
             collected_date,
         c.calculated_date
             commission_calculated_date,
         t.commission_receiver,
         t.reverse_reason,
         t.state
    FROM ifsapp.COMMISSION_VALUE_DETAIL t, ifsapp.COMM_BONS_INCEN_CLAIM c
   WHERE     t.claim_id = c.claim_id
         AND t.site = c.site
         AND t.commission_sales_type = 'HP'
         AND t.collection_type = 'INST'
         AND t.claim_id IS NOT NULL
         AND t.state = 'Approved'
         AND t.site LIKE '%$P!{SITE}%'
         AND TRUNC(c.calculated_date) BETWEEN $P{FROM_DATE}  and $P{TO_DATE}
ORDER BY t.site,
         t.order_no,
         t.receipt_no,
         t.catalog_no