/* Formatted on 10/8/2023 1:36:55 PM (QP5 v5.381) */
  SELECT customer_no,
         MAX (ORDER_NO)                                                       order_no,
         (ifsapp.customer_order_api.Get_Ord_Gross_Amount (MAX (ORDER_NO)))    last_order_value
    FROM (SELECT colt.customer_no,
                 order_no,
                   ROUND (
                       (  colt.buy_qty_due
                        * colt.price_conv_factor
                        * colt.sale_unit_price),
                       2)
                 - ROUND (
                         (  colt.buy_qty_due
                          * colt.price_conv_factor
                          * colt.sale_unit_price)
                       - (  (  colt.buy_qty_due
                             * colt.price_conv_factor
                             * colt.sale_unit_price)
                          * (  (1 - colt.discount / 100)
                             * (  1
                                -   (  colt.order_discount
                                     + colt.additional_discount)
                                  / 100))),
                       2)    last_order_value
            FROM ifsapp.customer_order_line_tab colt
           WHERE     1 = 1
                 AND colt.customer_no = 'W0003228-2'
                 AND colt.customer_no = 'W0003228-2'
                 AND ( :p_order_no IS NULL OR (colt.order_no = :p_order_no)))
GROUP BY customer_no;