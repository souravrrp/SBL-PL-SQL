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
       ifsapp.sbl_get_item_cost (l.catalog_no)
           unit_cost,
       ifsapp.sbl_get_item_cost (l.catalog_no) * l.buy_qty_due
           cost,
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
       ifsapp.customer_order_line_api.get_sale_price_total (l.order_no,
                                                            l.line_no,
                                                            l.rel_no,
                                                            l.line_item_no)
           discounted_nsp,
         ifsapp.customer_order_line_api.get_sale_price_total (l.order_no,
                                                              l.line_no,
                                                              l.rel_no,
                                                              l.line_item_no)
       * 0.17
           opex,
       ifsapp.customer_order_line_api.get_total_tax_amount (l.order_no,
                                                            l.line_no,
                                                            l.rel_no,
                                                            l.line_item_no)
           vat,
       (CASE
            WHEN l.contract = 'SITM'
            THEN
                  ifsapp.customer_order_line_api.get_sale_price_total (
                      l.order_no,
                      l.line_no,
                      l.rel_no,
                      l.line_item_no)
                * 0.01
            WHEN l.contract IN ('WSMO',
                                'JWSS',
                                'SAOS',
                                'SWSS',
                                'SSAM',
                                'SOSM')
            THEN
                  ifsapp.customer_order_line_api.get_sale_price_total (
                      l.order_no,
                      l.line_no,
                      l.rel_no,
                      l.line_item_no)
                * 0.03
            ELSE
                0
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
       (CASE
            WHEN ifsapp.customer_order_line_api.get_sale_price_total (
                     l.order_no,
                     l.line_no,
                     l.rel_no,
                     l.line_item_no) = 0
            THEN
                -1
            ELSE
                ROUND (
                      (  ifsapp.customer_order_line_api.get_sale_price_total (
                             l.order_no,
                             l.line_no,
                             l.rel_no,
                             l.line_item_no)
                       - ((  (  ifsapp.sbl_get_item_cost (l.catalog_no)
                              * l.buy_qty_due)
                           + (  ifsapp.sbl_get_item_cost (l.catalog_no)
                              * l.buy_qty_due
                              * .01))))
                    / (ifsapp.customer_order_line_api.get_sale_price_total (
                           l.order_no,
                           l.line_no,
                           l.rel_no,
                           l.line_item_no)),
                    2)
        END)
           gm,
         (CASE
              WHEN ifsapp.customer_order_line_api.get_sale_price_total (
                       l.order_no,
                       l.line_no,
                       l.rel_no,
                       l.line_item_no) = 0
              THEN
                  -1
              ELSE
                  ROUND (
                        (  ifsapp.customer_order_line_api.get_sale_price_total (
                               l.order_no,
                               l.line_no,
                               l.rel_no,
                               l.line_item_no)
                         - ((  (  ifsapp.sbl_get_item_cost (l.catalog_no)
                                * l.buy_qty_due)
                             + (  ifsapp.sbl_get_item_cost (l.catalog_no)
                                * l.buy_qty_due
                                * .01))))
                      / (ifsapp.customer_order_line_api.get_sale_price_total (
                             l.order_no,
                             l.line_no,
                             l.rel_no,
                             l.line_item_no)),
                      2)
          END)
       * 100
           gm_percentage,
       (CASE
            WHEN ifsapp.customer_order_line_api.get_sale_price_total (
                     l.order_no,
                     l.line_no,
                     l.rel_no,
                     l.line_item_no) = 0
            THEN
                'Non-Profitable'
            WHEN SIGN (
                       ROUND (
                             (  ifsapp.customer_order_line_api.get_sale_price_total (
                                    l.order_no,
                                    l.line_no,
                                    l.rel_no,
                                    l.line_item_no)
                              - ((  (  ifsapp.sbl_get_item_cost (
                                           l.catalog_no)
                                     * l.buy_qty_due)
                                  + (  ifsapp.sbl_get_item_cost (
                                           l.catalog_no)
                                     * l.buy_qty_due
                                     * .01))))
                           / (ifsapp.customer_order_line_api.get_sale_price_total (
                                  l.order_no,
                                  l.line_no,
                                  l.rel_no,
                                  l.line_item_no)),
                           2)
                     - 0.18) =
                 1
            THEN
                'Profitable'
            ELSE
                'Non-Profitable'
        END)
           profitability,
       ifsapp.customer_order_api.get_pay_term_id (l.order_no)
           pay_term_id,
       ifsapp.customer_order_api.get_state (l.order_no)
           state
  FROM ifsapp.customer_order_line l
 WHERE     ifsapp.customer_order_api.get_state (l.order_no) IN
               ('Planned', 'Released')
       AND ( :p_order_no IS NULL OR l.order_no = :p_order_no)
       AND TRUNC (l.date_entered) BETWEEN TO_DATE ('&FROM_DATE',
                                                   'YYYY/MM/DD')
                                      AND   TO_DATE ('&TO_DATE',
                                                     'YYYY/MM/DD')
                                          + 1
       AND l.vendor_no IS NOT NULL