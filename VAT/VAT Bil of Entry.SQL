/* Formatted on 12/18/2022 4:44:47 PM (QP5 v5.381) */
-- Purchase Receive through Import

SELECT R.shipment_id,
       s.note
           bil_of_entry_no,
       R.part_no,
       R.description,
       R.qty_arrived qty,
       (  IFSAPP.PURCHASE_ORDER_LINE_API.Get_Buy_Unit_Price (R.order_no,
                                                             R.line_no,
                                                             R.release_no)
        * R.qty_arrived)
           Total_Price
  FROM IFSAPP.PURCHASE_RECEIPT_NEW  R
       INNER JOIN IFSAPP.PURINV_SHIPMENTS S ON r.shipment_id = s.shipment_id
 WHERE     IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id ('SBL',
                                                          R.vendor_no,
                                                          'Supplier') =
           '0'
       AND TRUNC (R.arrival_date) BETWEEN TO_DATE ('&from_date',
                                                   'YYYY/MM/DD')
                                      AND TO_DATE ('&to_date', 'YYYY/MM/DD')
       AND R.state != 'Cancelled';