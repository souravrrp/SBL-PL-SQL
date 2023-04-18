/* Formatted on 3/2/2023 8:54:49 AM (QP5 v5.381) */
SELECT l.order_no,
       l.line_no,
       l.vendor_no
           "SITE",
       l.customer_no,
       IFSAPP.CUSTOMER_INFO_API.Get_Name (l.customer_no)
           customer_name,
       l.catalog_no,
       l.catalog_desc,
       TRUNC (l.date_entered)
           order_date,
       l.buy_qty_due
           quantiy,
       ROUND (l.cost, 2)
           unit_cost,
       ifsapp.customer_order_line_api.Get_Base_Sale_Price_Total (
           l.order_no,
           l.line_no,
           l.rel_no,
           l.line_item_no)
           base_price,
       l.base_sale_unit_price
           unit_nsp,
       l.base_sale_unit_price * l.buy_qty_due
           nsp,
       ifsapp.customer_order_line_api.get_total_discount (l.order_no,
                                                          l.line_no,
                                                          l.rel_no,
                                                          l.line_item_no)
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
       ifsapp.customer_order_line_api.get_total_tax_amount (l.order_no,
                                                            l.line_no,
                                                            l.rel_no,
                                                            l.line_item_no)
           vat,
       (CASE
            WHEN l.customer_no LIKE 'IT0%'
            THEN
                (l.base_sale_unit_price * l.buy_qty_due) * 0.01
            ELSE
                (l.base_sale_unit_price * l.buy_qty_due) * 0.032
        END)
           dealer_incentive,
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
       ifsapp.customer_order_api.get_pay_term_id (l.order_no)
           pay_term_id,
       ifsapp.customer_order_api.get_state (l.order_no)
           state
  FROM ifsapp.customer_order_line l
 WHERE     l.vendor_no IS NOT NULL
       AND l.customer_no = :p_customer_no
       --AND TO_CHAR (l.date_entered, 'RRRR') BETWEEN :p_from_year AND :p_to_year
       --AND TO_CHAR (l.date_entered, 'MON') BETWEEN :p_from_period AND :p_to_period
       AND EXTRACT(YEAR FROM l.date_entered) BETWEEN :p_from_year
                                                AND :p_to_year
       AND EXTRACT(MONTH FROM l.date_entered) BETWEEN :p_from_period
                                               AND :p_to_period;