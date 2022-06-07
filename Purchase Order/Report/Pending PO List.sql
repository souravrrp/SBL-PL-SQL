/* Formatted on 6/6/2022 5:14:22 PM (QP5 v5.381) */
SELECT pot.order_no,
       pot.contract           shop_code,
       pot.rowstate           status,
       pot.authorize_code     creator,
       pot.delivery_address
  FROM ifsapp.purchase_order_tab pot, ifsapp.purchase_order_line_tab polt
 WHERE     1 = 1
       AND pot.order_no = polt.order_no
       --AND pot.order_no = 'A-26760734'
       AND pot.order_date BETWEEN TO_DATE ('&from_date', 'YYYY/MM/DD')
                              AND TO_DATE ('&to_date', 'YYYY/MM/DD')
       AND pot.rowstate NOT IN ('Cancelled', 'Closed')
       AND polt.rowstate NOT IN ('Cancelled', 'Closed')
       AND ORDER_SENT = 'SENT'
       AND EXISTS
               (SELECT 1
                  FROM ifsapp.customer_order co
                 WHERE     1 = 1
                       --AND co.customer_po_no = 'A-26760734'
                       AND co.customer_po_no = pot.order_no
                       AND co.objstate NOT IN
                               ('Cancelled', 'Closed', 'Invoiced/Closed')
                       AND co.state NOT IN
                               ('Cancelled', 'Closed', 'Invoiced/Closed'));


--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.purchase_order_tab pot, ifsapp.purchase_order_line_tab polt
 WHERE     1 = 1
       AND pot.order_no = polt.order_no
       AND pot.order_no = 'A-26760734'
       AND pot.rowstate NOT IN ('Cancelled', 'Closed')
       AND polt.rowstate NOT IN ('Cancelled', 'Closed');



SELECT *
  FROM ifsapp.customer_order co
 WHERE     1 = 1
       --AND co.customer_po_no = 'A-26760734'
       AND co.objstate NOT IN ('Cancelled', 'Closed', 'Invoiced/Closed')
       AND co.state NOT IN ('Cancelled', 'Closed', 'Invoiced/Closed');

--------------------------------------------------------------------------------


SELECT *
  FROM ifsapp.sbl_vw_active_po svap;