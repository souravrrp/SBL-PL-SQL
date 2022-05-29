/* Formatted on 5/29/2022 10:14:08 AM (QP5 v5.381) */
SELECT t4.ORDER_NO,
       t2.PART_NO,
       t4.delnote_no,
       t4.QTY_SHIPPED,
       t4.DATE_DELIVERED
  FROM ifsapp.customer_order_delivery_tab  t4,
       ifsapp.Customer_Order_Line_tab      t2
 WHERE     t2.order_no = t4.order_no
       AND t2.line_no = t4.line_no
       AND t2.rel_no = t4.rel_no
       AND t2.line_item_no = t4.line_item_no
       AND t2.DEMAND_ORDER_REF1 LIKE '&PO_NO';