/* Formatted on 2/1/2023 12:57:31 PM (QP5 v5.381) */
SELECT l.order_no,
       l.line_no,
       --l.contract "SITE",
       l.vendor_no
           delivery_site,
       l.customer_no,
       IFSAPP.CUSTOMER_INFO_API.Get_Name (l.customer_no)
           customer_name,
       l.catalog_no,
       l.catalog_desc,
       TRUNC (l.date_entered)
           order_date,
       l.buy_qty_due
           quantiy,
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
         ROUND (
               (  ifsapp.customer_order_line_api.get_sale_price_total (
                      l.order_no,
                      l.line_no,
                      l.rel_no,
                      l.line_item_no)
                - (  (ROUND (l.cost, 2) * l.buy_qty_due)
                   + (ROUND (l.cost, 2) * l.buy_qty_due * .01)))
             / (ROUND (l.cost, 2) * l.buy_qty_due),
             2)
       * 100
           gm_percentage,
       ifsapp.customer_order_api.get_pay_term_id (l.order_no)
           pay_term_id,
       ifsapp.customer_order_api.get_state (l.order_no)
           state,
       l.*
  FROM ifsapp.customer_order_line l
 WHERE     ifsapp.customer_order_api.get_state (l.order_no) = 'Planned'
       AND l.order_no = 'WSM-R115005'
       AND TRUNC (l.date_entered) BETWEEN TO_DATE ('&FROM_DATE',
                                                   'YYYY/MM/DD')
                                      AND TO_DATE ('&TO_DATE', 'YYYY/MM/DD')