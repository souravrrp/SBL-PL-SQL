/* Formatted on 3/23/2023 2:31:03 PM (QP5 v5.381) */
SELECT l.order_no,
       L.line_no,
       L.vendor_no
           "SITE",
       L.customer_no,
       IFSAPP.CUSTOMER_INFO_API.Get_Name (l.customer_no)
           customer_name,
       L.catalog_no,
       L.catalog_desc,
       TRUNC (l.date_entered)
           order_date,
       L.buy_qty_due
           quantiy,
       (  ifsapp.customer_order_line_api.get_sale_price_total (
              l.order_no,
              l.line_no,
              l.rel_no,
              l.line_item_no)
        + ifsapp.customer_order_line_api.get_total_tax_amount (
              l.order_no,
              l.line_no,
              l.rel_no,
              l.line_item_no))
           discounted_rsp,
       L.base_sale_unit_price
           unit_nsp,
       L.base_sale_unit_price * l.buy_qty_due
           nsp,
       ifsapp.customer_order_line_api.get_total_tax_amount (l.order_no,
                                                            l.line_no,
                                                            l.rel_no,
                                                            l.line_item_no)
           vat,
       ifsapp.customer_order_line_api.get_total_discount (L.order_no,
                                                          L.line_no,
                                                          L.rel_no,
                                                          L.line_item_no)
           discount_percent,
         (l.base_sale_unit_price * l.buy_qty_due)
       * (  ifsapp.customer_order_line_api.get_total_discount (
                l.order_no,
                l.line_no,
                l.rel_no,
                l.line_item_no)
          / 100)
           discount_amt,
       ifsapp.customer_order_line_api.get_sale_price_total (l.order_no,
                                                            l.line_no,
                                                            l.rel_no,
                                                            l.line_item_no)
           discounted_nsp,
       (CASE
            WHEN l.customer_no LIKE 'IT0%'
            THEN
                (l.base_sale_unit_price * l.buy_qty_due) * 0.01
            ELSE
                (l.base_sale_unit_price * l.buy_qty_due) * 0.032
        END)
           dealer_incentive,
       ROUND (l.cost, 2)
           unit_cost,
       --       ifsapp.customer_order_line_api.Get_Base_Sale_Price_Total (
       --           L.order_no,
       --           L.line_no,
       --           L.rel_no,
       --           L.line_item_no)
       --           base_price,
       ifsapp.customer_order_api.get_pay_term_id (l.order_no)
           pay_term_id,
       ifsapp.customer_order_api.get_state (l.order_no)
           state
  FROM ifsapp.customer_order_line l
 WHERE     l.vendor_no IS NOT NULL
       AND l.order_no = 'WSM-R119139'
       --AND ifsapp.customer_order_api.get_state (l.order_no) in ('Delivered')
       --       AND l.customer_no like 'W0%'
       AND TRUNC (l.date_entered) BETWEEN NVL ( :p_date_from,
                                               TRUNC (l.date_entered))
                                      AND NVL ( :p_date_to,
                                               TRUNC (l.date_entered))