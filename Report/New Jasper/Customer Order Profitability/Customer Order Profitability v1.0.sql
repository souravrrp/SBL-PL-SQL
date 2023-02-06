SELECT l.order_no,
       l.line_no,
       l.contract
           "SITE",
       l.customer_no,
       l.catalog_no,
       l.catalog_desc,
       TRUNC (l.date_entered)
           order_date,
       l.buy_qty_due
           quantiy,
       ROUND (l.cost, 2)
           unit_cost,
       ROUND (l.cost, 2) * l.buy_qty_due
           cost,
       l.base_sale_unit_price
           unit_nsp,
       l.base_sale_unit_price * l.buy_qty_due
           nsp,
       ifsapp.customer_order_line_api.get_total_discount (l.order_no,
                                                          l.line_no,
                                                          l.rel_no,
                                                          l.line_item_no)
           discount_percent,
       ifsapp.customer_order_line_api.get_sale_price_total (l.order_no,
                                                            l.line_no,
                                                            l.rel_no,
                                                            l.line_item_no)
           discounted_nsp,
       ifsapp.customer_order_line_api.get_total_tax_amount (l.order_no,
                                                            l.line_no,
                                                            l.rel_no,
                                                            l.line_item_no)
           vat,
       ROUND ((  ifsapp.customer_order_line_api.get_sale_price_total (
                     l.order_no,
                     l.line_no,
                     l.rel_no,
                     l.line_item_no)
               - (ROUND (l.cost, 2) * l.buy_qty_due)),
              2)
           gm,
         ROUND (  (  ifsapp.customer_order_line_api.get_sale_price_total (
                         l.order_no,
                         l.line_no,
                         l.rel_no,
                         l.line_item_no)
                   - (ROUND (l.cost, 2) * l.buy_qty_due))
                / (ROUND (l.cost, 2) * l.buy_qty_due),
                2)
       * 100
           gm_percentage,
       ifsapp.customer_order_api.get_pay_term_id (l.order_no)
           pay_term_id,
       ifsapp.customer_order_api.get_state (l.order_no)
           state,
       (CASE
            WHEN   ROUND (  (  ifsapp.customer_order_line_api.get_sale_price_total (
                                   l.order_no,
                                   l.line_no,
                                   l.rel_no,
                                   l.line_item_no)
                             - (ROUND (l.cost, 2) * l.buy_qty_due))
                          / (ROUND (l.cost, 2) * l.buy_qty_due),
                          2)
                 * 100 >= 50
            THEN
                'Red'
            WHEN       ROUND (  (  ifsapp.customer_order_line_api.get_sale_price_total (
                                       l.order_no,
                                       l.line_no,
                                       l.rel_no,
                                       l.line_item_no)
                                 - (ROUND (l.cost, 2) * l.buy_qty_due))
                              / (ROUND (l.cost, 2) * l.buy_qty_due),
                              2)
                     * 100 < 50
                 AND   ROUND (  (  ifsapp.customer_order_line_api.get_sale_price_total (
                                       l.order_no,
                                       l.line_no,
                                       l.rel_no,
                                       l.line_item_no)
                                 - (ROUND (l.cost, 2) * l.buy_qty_due))
                              / (ROUND (l.cost, 2) * l.buy_qty_due),
                              2)
                     * 100 >= 25
            THEN
                'Yellow'
            ELSE
                'Green'
        END)
           line_color
  FROM ifsapp.customer_order_line l
 WHERE     ifsapp.customer_order_api.get_state (l.order_no) = 'Planned'
       AND $X{IN, l.order_no, ORDER_NUMBER}
       AND l.order_no LIKE '%$P!{ORDER_NUMBER}%')