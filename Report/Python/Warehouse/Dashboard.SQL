/* Formatted on 10/25/2022 10:25:55 AM (QP5 v5.381) */
  SELECT colt.order_no,
         colt.contract                tr_place,
         ecot.internal_po_no          doc_ref1,
         TRUNC (polt.rowversion)      tr_date,
         colt.catalog_no              part_code,
         polt.actual_qty_reserved     qty_out,
         polt.debit_note_no,
         --polt.debit_note_no           doc_ref2,
         --ecot.customer_no             dest_source,
         polt.debit_note_no           debit_note
    FROM ifsapp.customer_order_line_tab    colt,
         ifsapp.external_customer_order_tab ecot,
         ifsapp.trn_trip_plan_co_line_tab  polt,
         ifsapp.purchase_order_line_tab    o
   WHERE     colt.order_no = ecot.order_no
         AND colt.order_no = polt.order_no
         AND colt.line_no = polt.line_no
         AND colt.rel_no = polt.rel_no
         AND ecot.internal_po_no = o.order_no
         --AND colt.contract in ( 'ABCW','SRMF','CMWH')
         AND colt.rowstate IN ('Invoiced', 'Delivered', 'PartiallyDelivered')
         AND TO_DATE (TO_CHAR (TRUNC (polt.rowversion), 'dd-MON-yy')) BETWEEN TO_DATE (
                                                                                  '2022/10/22',
                                                                                  'yyyy/mm/dd')
                                                                          AND TO_DATE (
                                                                                  '2022/10/22',
                                                                                  'yyyy/mm/dd')
         AND cust_ord_customer_api.get_cust_grp (
                 customer_order_api.get_customer_no (o.demand_order_no))
                 IS NULL
ORDER BY polt.debit_note_no;