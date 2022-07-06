/* Formatted on 7/4/2022 10:29:16 AM (QP5 v5.381) */
  SELECT l.site,
         l.commission_receiver,
         TO_CHAR (l.calculated_date, 'YYYY/MM/DD')     calculated_date,
         l.entitlement_type,
         l.gross_amount,
         l.approved_amount,
         l.deduction_amount,
         l.state
    FROM IFSAPP.COMM_BONS_INCEN_CLAIM L
   WHERE     l.calculated_date BETWEEN TO_DATE ('&FROM_DATE', 'YYYY/MM/DD')
                                   AND TO_DATE ('&TO_DATE', 'YYYY/MM/DD')
         AND l.site LIKE UPPER ('%&SHOP_CODE%')
ORDER BY l.site, l.claim_id