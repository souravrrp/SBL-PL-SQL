/* Formatted on 4/3/2023 10:40:47 AM (QP5 v5.381) */
SELECT poit.order_no,
       poit.line_no,
       poit.release_no,
       poit.receipt_no,
       poit.series_id         invoice_series,
       poit.ap_invoice_no     invoice_no,
       poit.part_no           item,
       poit.contract          site_code,
       poit.qty_invoiced,
       poit.unit_price_paid,
       poit.purchase_matching_type,
       poit.date_entered,
       poit.matching_date
  --,poit.*
  FROM ifsapp.purchase_order_invoice_tab poit
 WHERE     1 = 1
       AND ( :p_po_no IS NULL OR (UPPER (poit.order_no) = UPPER ( :p_po_no)))
       AND TRUNC (poit.date_entered) BETWEEN NVL ( :p_date_from,
                                                  TRUNC (poit.date_entered))
                                         AND NVL ( :p_date_to,
                                                  TRUNC (poit.date_entered));